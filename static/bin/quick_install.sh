#!/bin/bash

#SCRIPT_DIR=$(dirname $0)

#K8S_RELEASE=1.18.6
#K8S_RELEASE=1.18.1
K8S_RELEASE=1.19.2
POD_CIDR=192.168.0.0/16

APT_K8S_RELEASE=${K8S_RELEASE}-00

[ -d /home/ubuntu ]  && END_USER=ubuntu
[ -d /home/student ] && END_USER=student
#[ -d /home/* ] && { END_USER=$(ls -d /home/*); END_USER=${END_USER#/home/}; }
[ "$END_USER" != "${END_USER## *}" ] && die "Failed to determine END_USER"
#echo END_USER=$END_USER

#exit 0

APT_INSTALL_PACKAGES_1="jq zip vim"
APT_INSTALL_PACKAGES_1+=" docker.io"
#[ $ANSIBLE_INSTALL -eq 1 ] && APT_INSTALL_PACKAGES_1+=" ansible ansible-lint ansible-tower-cli ansible-tower-cli-doc"

APT_INSTALL_PACKAGES_2+=" kubeadm=$APT_K8S_RELEASE kubelet=$APT_K8S_RELEASE kubectl=$APT_K8S_RELEASE"
#APT_INSTALL_PACKAGES_2+=" nfs-common"

## Fns: -----------------------------------------------------------------------

die() {
    #ERROR $*
    echo "$0: die - Installation failed" >&2 # | SECTION_LOG
    echo $* >&2
    exit 1
}

press() {
    echo $*
    echo "Press <enter>"
    read DUMMY
    [ "$DUMMY" = "q" ] && exit 0
    [ "$DUMMY" = "Q" ] && exit 0
}

# Safer version of apt-get when locking is blocking us:
safe_apt_get() {
    PKGS=$*
    press "apt-get $PKGS"
    apt-get $PKGS; RET=$?

    local _MAX_LOOP=12
    while [ $RET -ne 0 ]; do
        for lock in /var/lib/dpkg/lock*; do
	    echo "lsof $lock:"
	    lsof $lock
	done

	sleep 10
        let _MAX_LOOP=_MAX_LOOP-1
        [ $_MAX_LOOP -le 0 ] && { echo "Failed apt-get $PKGS ... continuing"; return 1; }
        apt-get $PKGS; RET=$?
    done
    return 0
}

## Check worker1 connectivity:
CHECK_CONNECTIVITY() {
    local NODE=$1; shift

    [ "${NODE#[0-9]}" != "$NODE" ] && die "Bad node name '$NODE' for master/worker"

    echo "Checking/adding k8smaster entry in /etc/hosts:"
    grep -q " k8smaster" /etc/hosts || {
        echo "Adding master entry to /etc/hosts:"
        set -x; echo "$(hostname -i) k8smaster" | tee -a /etc/hosts; set +x
    }

    echo "Checking '$NODE' entry in /etc/hosts:"
    grep -q " $NODE" /etc/hosts ||
        die "You must configure the private ip address of '$NODE' in /etc/hosts"

    echo "Checking connectivity to $NODE:"
    ssh $NODE uptime || {
        echo "Failed ssh as root to $NODE ... configuring ..."
        sudo cp /home/$END_USER/.ssh/id_rsa{,.pub} /root/.ssh/
        #set -x; ssh -i /home/$END_USER/.ssh/id_rsa $END_USER@$NODE sudo "cat /home/$END_USER/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys"; set +x
        #set -x; ssh -i /home/$END_USER/.ssh/id_rsa $END_USER@$NODE sudo "cat /home/$END_USER/.ssh/id_rsa.pub | tee -a /root/.ssh/authorized_keys"; set +x
        #set -x; ssh -i /home/$END_USER/.ssh/id_rsa $END_USER@$NODE sudo bash -c "set -x; cat /home/$END_USER/.ssh/id_rsa.pub | tee -a /root/.ssh/authorized_keys"; set +x
        set -x; ssh -i /home/$END_USER/.ssh/id_rsa $END_USER@$NODE "sudo bash -c 'set -x; cat /home/$END_USER/.ssh/id_rsa.pub | tee -a /root/.ssh/authorized_keys; set +x'"
    }
    ssh $NODE uptime ||
        die "You must pre-configure ssh access to $NODE"
}

INSTALL_PACKAGES() {
    local APT_INSTALL_PACKAGES="$1"; shift
    ## Install packages:
    safe_apt_get update
    safe_apt_get upgrade -y
    safe_apt_get install -y $APT_INSTALL_PACKAGES
}

SETUP_DOCKER() {
    systemctl start docker
    systemctl enable docker
    echo "$USER: docker ps"
    docker ps

    grep -q docker: /etc/group || groupadd docker
    usermod -aG docker $END_USER
    { echo "$END_USER: docker ps"; sudo -iu $END_USER docker ps; }
    docker version -f "Docker Version Client={{.Client.Version}} Server={{.Server.Version}}"
}

KUBEADM_INIT() {
    #kubeadm init --kubernetes-version=$K8S_RELEASE --pod-network-cidr=$POD_CIDR --apiserver-cert-extra-sans=__MASTER1_IP__ | tee kubeadm-init.out
    SHOWCMD kubeadm reset
    [ -d /etc/kubernetes ] && mv /etc/kubernetes /etc/kubernetes.bak
    [ -d /var/lib/etcd ] && rm -rf /var/lib/etcd
    SHOWCMD kubeadm init --node-name master --kubernetes-version=$K8S_RELEASE --pod-network-cidr=$POD_CIDR | tee kubeadm-init.out

    mkdir -p /home/$END_USER/.kube
    cp -a /etc/kubernetes/admin.conf /home/$END_USER/.kube/config
    chmod 500 /home/$END_USER/.kube
    chmod 400 /home/$END_USER/.kube/config
    chown -R $END_USER:users /home/$END_USER/.kube

    mkdir /root/.kube
    cp -a /etc/kubernetes/admin.conf /root/.kube/config
}

REMOTE_PREPA() {
    local NODE=$1; shift

    SHOWCMD ssh $NODE apt-get update
    SHOWCMD ssh $NODE apt-get upgrade -y
    SHOWCMD ssh $NODE apt-get install -y $APT_INSTALL_PACKAGES_1

    #SHOWCMD ssh $NODE echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | SHOWCMD ssh $NODE tee /etc/apt/sources.list.d/kubernetes.list
    SHOWCMD ssh $NODE curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    SHOWCMD ssh $NODE apt-get update
    SHOWCMD ssh $NODE apt-get upgrade -y
    SHOWCMD ssh $NODE apt-get install -y $APT_INSTALL_PACKAGES_2
    SHOWCMD ssh $NODE apt-mark hold kubelet kubeadm kubectl
}

REMOTE_KUBEADM_JOIN_MASTER() {
    local NODE=$1; shift

    MASTER_CERT=$(kubeadm alpha certs certificate-key)

    JOIN_COMMAND=$(kubeadm token create --print-join-command)
    [ -z "$JOIN_COMMAND" ] && die "REMOTE_KUBEADM_JOIN_MASTER: Failed to get join command"

    JOIN_COMMAND+=" --control-plane --certificate-key $MASTER_CERT"

    SHOWCMD ssh $NODE sudo "[ -f /etc/kubernetes ] && rm -rf /etc/kubernetes"
    SHOWCMD ssh $NODE sudo "kubeadm reset"
    SHOWCMD ssh $NODE sudo "[ -f //var/lib/etcd ] && rm -rf //var/lib/etcd"

    SHOWCMD ssh $NODE sudo $JOIN_COMMAND --node-name $NODE
}

REMOTE_KUBEADM_JOIN() {
    local NODE=$1; shift

    JOIN_COMMAND=$(kubeadm token create --print-join-command)
    [ -z "$JOIN_COMMAND" ] && die "REMOTE_KUBEADM_JOIN: Failed to get join command"

    SHOWCMD ssh $NODE sudo "[ -f /etc/kubernetes ] && rm -rf /etc/kubernetes"
    SHOWCMD ssh $NODE sudo "kubeadm reset"
    SHOWCMD ssh $NODE sudo "[ -f //var/lib/etcd ] && rm -rf //var/lib/etcd"

    SHOWCMD ssh $NODE sudo $JOIN_COMMAND --node-name $NODE
}

SHOWCMD() {
    CMD="$*"
    echo "-- $CMD"
    $CMD
    RET=$?
    [ $RET -ne 0 ] && echo "--> returned $RET"
}

INSTALL_NODE_PACKAGES() {
    INSTALL_PACKAGES $APT_INSTALL_PACKAGES_1
    SETUP_DOCKER

    echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

    INSTALL_PACKAGES $APT_INSTALL_PACKAGES_2
    apt-mark hold kubelet kubeadm kubectl
}

INSTALL_MASTER1() {
    INSTALL_NODE_PACKAGES

    KUBEADM_INIT
    wget -qO calico.yaml.orig https://docs.projectcalico.org/manifests/calico.yaml
    sed -e 's/# - name: CALICO_IPV4POOL_CIDR/- name: CALICO_IPV4POOL_CIDR/' \
        -e 's|#   value: "192.168.0.0/16"|  value: "192.168.0.0/16"|' calico.yaml.orig  > calico.yaml

    diff calico.yaml.orig calico.yaml
    kubectl apply -f calico.yaml

    UNTAINT_NODES
}

UNTAINT_NODES() {
    echo; echo "-- Taints"
    echo "Before:"
    kubectl describe nodes | grep Taints:

    kubectl taint nodes --all node-role.kubernetes.io/master-

    echo
    echo "After: (should be None)"
    kubectl describe nodes | grep Taints:
}

INSTALL_MASTER() {
    MASTER=$1; shift;

    [ "$MASTER" = "1" ] && die "Use this for extra master nodes, not 1st"

    #INSTALL_NODE_PACKAGES

    echo
    press "---- Installing on $MASTER -----------------------------------------"
    #echo "CHECK_CONNECTIVITY  $MASTER"
    CHECK_CONNECTIVITY  $MASTER
    REMOTE_PREPA        $MASTER
    REMOTE_KUBEADM_JOIN_MASTER $MASTER
}

INSTALL_WORKER() {
    WORKER=$1; shift;

    CHECK_CONNECTIVITY  $WORKER
    REMOTE_PREPA        $WORKER
    REMOTE_KUBEADM_JOIN $WORKER
}

INSTALL_MASTERS_WORKERS() {
    NUM_MASTERS=$1; shift;
    NUM_WORKERS=$1; shift;

    [ $NUM_MASTERS -gt 1 ] && die "Only 1 master implemented for now ..."
    INSTALL_MASTER1

    for NUM_WORKER in $(seq $NUM_WORKERS); do
        WORKER=worker$NUM_WORKER

        CHECK_CONNECTIVITY  $WORKER
    done

    for NUM_WORKER in $(seq $NUM_WORKERS); do
        WORKER=worker$NUM_WORKER

        INSTALL_WORKER $WORKER
    done
}

## Args: ----------------------------------------------------------------------

[ `id -un` = 'root' ] || die "Must be run as root"

while [ ! -z "$1" ]; do
    case $1 in
        -x) set -x ;;

        -I) INSTALL_MASTERS_WORKERS 1 1; exit $?;;

        -i) INSTALL_MASTER1; exit $?;;

        -w) shift; WORKER=$1; INSTALL_WORKER $WORKER; exit $?;;
        -m) shift; MASTER=$1; INSTALL_MASTER $MASTER; exit $?;;

        *) die "Unknown option '$1'";; 
    esac
    shift
done

## Main: ----------------------------------------------------------------------

#echo "INSTALL $APT_INSTALL_PACKAGES_1"
#INSTALL_PACKAGES $APT_INSTALL_PACKAGES_1
INSTALL_NODE_PACKAGES

exit 0


##### HISTORY master (sudo -i)

   1  sudo apt-get update
    2  sudo apt-get upgrade -y
    3  /home/student/quick_install.sh
    4  vi /etc/hosts
          10.142.0.13 k8master
          10.142.0.38 worker worker1

    7  ssh-keygen -N '' -t rsa
    8  cat .ssh/id_rsa.pub
    9  ssh worker1 uptime
   10  ll .ssh/
   11  ssh student@worker1 uptime
   12  history



##### HISTORY worker (sudo -i)

   1  hostname
    2  hostname -i
    3  sudo vi /etc/hosts
             10.142.0.13 k8master

    4  vi .ssh/authorized_keys
    5  history



