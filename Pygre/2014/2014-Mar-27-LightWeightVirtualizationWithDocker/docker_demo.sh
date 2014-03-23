#!/bin/bash 
#!/bin/sh 

#DTIME=`date +%d-%b-%y_%Hh%Mm`

DEBUG=0

################################################################################
## Notes:

# On a side note, I recently set up apache to run in a container on it's own and ran into some issues getting it started if you are handling SSL traffic. Just make sure you set the following environment variables and you should be fine
# 
# # From my Dockerfile
# ENV APACHE_RUN_USER www-data
# ENV APACHE_RUN_GROUP www-data
# ENV APACHE_RUN_DIR /var/run/apache2
# ENV APACHE_LOG_DIR /var/log/apache2 

# DOCKERFILE:
# FROM ubuntu
# RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe > /etc/apt/sources.list
# RUN apt-get update
# RUN apt-get install -y mysql-server mysql-client
# RUN apt-get install -y apache2 apache2-mpm-prefork apache2-utils apache2.2-common libapache2-mod-php5 libapr1 libaprutil1 libdbd-mysql-perl libdbi-perl libnet-daemon-perl libplrpc-perl libpq5 mysql-common php5-common php5-mysql
# RUN apt-get install -y vim wget net-tools
# RUN wget http://wordpress.org/latest.tar.gz && mv latest.tar.gz /var/www
# EXPOSE 80



################################################################################
## General functions:

die() {
    echo "$0: die - $*" >&2
    exit 1
}

pause() {
    [ ! -z "$1" ] && echo $*
    echo "Press <return> to continue"
    read _DUMMY
    [ "$_DUMMY" = "q" ] && exit 0
    [ "$_DUMMY" = "Q" ] && exit 0
}

interrupt() {
    echo "you hit Ctrl-C/Ctrl-\, now continuing ..."
    exit 1
}

GIT_SCRIPT_DIR="$HOME/src/git/mjbright-tools"
GIT_PRES_DIR="$HOME/z/www/mjbright.github.io/Pygre/2014/2014-Mar-27-LightWeightVirtualizationWithDocker/"

viSlides() {
    cd $GIT_PRES_DIR
    vi Slides.md
    landslide -r -c Slides.md
    ls -altr
}

gitPush() {
    name="Michael Bright"
    email="github@mjbright.net"
    #user="mjbright"
    git config --global user.name $name
    git config --global user.email $email
    #read -p "Enter github password: " -s MDP

    [ -d $GIT_SCRIPT_DIR ] && {
        cp $0 $GIT_SCRIPT_DIR/;
        cd $GIT_SCRIPT_DIR/;
        git commit -m "Semi-auto push: Updated script++" -a;
        git push ssh://mjbright@github.com/mjbright/Tools;
    }

    cp $0 $GIT_PRES_DIR/
    cd $GIT_PRES_DIR
    git commit -m "Semi-auto push: Updated script++" -a
    git push
    #[ ! -d ~/src/git/mjbright-docker ] 
}

dtime() { date +%d-%b-%y_%Hh%Mm%Ss; }

# function called by trap
other_commands() {
    echo "\rSIGINT caught      "
    #printf "\rSIGINT caught      "
    sleep 1
    #printf "\rType a command >>> "
}
#trap 'interrupt' SIGINT SIGQUIT
trap 'other_commands' SIGINT SIGQUIT
#trap 'interrupt' SIGINT SIGQUIT
## set -x
## trap 'echo you hit Ctrl-C/Ctrl-\, now exiting..; exit' SIGINT SIGQUIT
## set +x


################################################################################
## Docker utulity functions:

startRepo() {

    cd /home/mjb/src/git/docker-registry
    
    echo
    echo "Gunicorn launch:"
    gunicorn --access-logfile - --log-level debug --debug \
        -b 0.0.0.0:5000 -w 1 wsgi:application
}

RMALL() {
    RUNNING_DOCKER_IDS=`docker ps | awk '!/^CONTAINER/ { print $1; }'`
    DOCKER_IDS=`docker ps -a | awk '!/^CONTAINER/ { print $1; }'`
    echo "Stopping/Removing all containers";

    [ ! -z "$RUNNING_DOCKER_IDS" ] && {
        DEBUG "Stopping running containers";
        SHOW_DOCKER stop $DOCKER_IDS;
    }

    [ -z "$DOCKER_IDS" ] && {
        echo "No Docker containers";
        return 1;
    }

    SHOW_DOCKER rm $DOCKER_IDS
}

SHOW_DOCKER() {
     echo "docker $@"
     eval docker $@
}

GETLASTID() {
     docker ps -q -a -l
}

GETLASTFULLID() {
     docker ps -q -a -l --no-trunc
}

LIST() {
    echo; echo "Current running docker containers:"
    SHOW_DOCKER ps
}

LIST_ALL() {
    echo; echo "Current running/exited docker containers:"
    SHOW_DOCKER ps -a
}

PAUSE_DOCKER() {
     #pause "About to 'docker $*'"
     echo "docker $@"
     eval docker $@
     pause ""
}

BANNER() {
    echo; echo; echo; echo; echo; echo; echo; echo;
    echo "================================================================"
    #for LINE in $@;do echo "== $LINE"; done
    echo "== $@"
    echo "================================================================"
}

DEBUG() {
    [ $DEBUG -ne 0 ] && echo "DEBUG: $*"
}

DEBUG_BANNER() {
    [ $DEBUG -ne 0 ] && BANNER "$@"
}

################################################################################
## Docker demo script functions:

SHOW_THREADS() {
     DOCKER_PID=`pstree -ap | perl -ne 'if (/docker,(\d+)/) { print $1; }'`
     pstree -apl $DOCKER_PID
}

DEMO1() {
     DEBUG_BANNER "Show basic container launching in interactive mode"

     echo; pause "Removing any existing docker containers:"
     RMALL
     LIST_ALL
     pause

     echo; pause "Starting Docker container in interactive mode: 'hello world'"
     SHOW_DOCKER run --name HelloWorld_`dtime` -i -t base echo 'hello world'

     echo; pause "Let's look at current Docker containers"
     LIST_ALL
     RMALL

     echo; pause "Starting long-lived Docker container in interactive mode:"
     #CMD="while true;do echo 'hello world'; date; sleep 1;done"
     #CMD="while true;do echo \`date\` 'hello world'; sleep 1;done"
     CMD="while true;do echo \\\$(date) 'hello world'; sleep 1;done"
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""

}

DEMO2() {
     DEBUG_BANNER "Show daemon container launching"
     RMALL

     NAME=DAEMON`dtime`

     echo; pause "About to start container as daemon"
     CMD="while true;do let LOOP=LOOP+1; echo \\\$LOOP:'STDERR' >&2; echo \\\$(date) 'hello world'; sleep 1;done"
     #SHOW_DOCKER run --name=$NAME -a stdout -a stderr -d -t base /bin/bash -c "\"$CMD\""
     SHOW_DOCKER run --name=$NAME -d -t base /bin/bash -c "\"$CMD\""

     echo; pause "Let's look at process threads on host system"
     echo; echo "Host process threads (ps output):"
     SHOW_THREADS
     echo; echo "Docker containers:"
     LIST_ALL

     echo; pause "Let's look at what's happening on the host filesystem"
     echo "sudo ls -altr /var/lib/docker/containers:"
     sudo ls -altr /var/lib/docker/containers

     CONTAINER_ID=`sudo ls -tr /var/lib/docker/containers | tail -1`
     echo; echo CONTAINERID=$CONTAINER_ID

     LOG=/var/lib/docker/containers/$CONTAINER_ID/${CONTAINER_ID}-json.log
     echo
     sudo ls -altr $LOG
     #sudo tail -1 $LOG
     echo; pause "Now let's tail that log file [last 2 lines]"
     sudo tail -2 $LOG

     echo; pause "Now let's tail that log file"
     sudo tail -f $LOG

     #echo; echo "sleep 2"
     #sleep 2
     #echo
     #sudo ls -altr $LOG
     #sudo tail -1 $LOG

     pause "Daemon is running, now let's follow it"
     SHOW_DOCKER attach $NAME
}

DEMO3() {
    DEBUG_BANNER "Run daemon whilst mounting /var/log of container to $DIR"
    RMALL
    MOUNT_DIR
}

DEMO4() {
    SETUP_WORDPRESS
}

DEMO5() {
    DEMO_UNIONFS
}

SETUP_WORDPRESS() {
    DOCKERFILE=/tmp/wordpress.dockerfile
    YES=""
    YES="-y"
    cat > $DOCKERFILE <<EOF
FROM ubuntu
#FROM base
RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install $YES mysql-server mysql-client
RUN apt-get install $YES apache2 apache2-mpm-prefork apache2-utils apache2.2-common libapache2-mod-php5 libapr1 libaprutil1 libdbd-mysql-perl libdbi-perl libnet-daemon-perl libplrpc-perl libpq5 mysql-common php5-common php5-mysql
RUN apt-get install $YES vim wget net-tools
RUN wget http://wordpress.org/latest.tar.gz && mv latest.tar.gz /var/www
EXPOSE 80
EOF

    docker -t wpress build - < $DOCKERFILE

    docker run wpress -p 80:80
    ID=wpress
    FULLID=`GETFULLID $ID`
    echo "/etc/init.d/apache2 start" | sudo lxc-attach --name $FULLID


    wget localhost:80

}

MOUNT_DIR() {
    DIR=/var/myapp/log
    LOG=$DIR/mounted.log

    [ ! -d $DIR ] && sudo mkdir -p $DIR
    sudo chown $USER $DIR
    [ -f $LOG ] && rm -f $LOG

    #CMD="while true;do sleep 1; date >> /var/log/mounted.log; done"
    CMD="while true;do let LOOP=LOOP+1; sleep 1; date >> /var/log/mounted.log; echo OK\$LOOP; done"
    echo; pause "About to launch $CMD"
    ID=`docker run --name MNT_EXAMPLE -v $DIR:/var/log -d -t base /bin/bash -c "$CMD"`

    sleep 2;
    echo; echo "Contents of $DIR/";
    sudo ls -altr $DIR/

    echo; echo "Tail of file $DIR/mounted.log:"

    trap 'echo "Interrupt"' SIGINT
    sudo tail -f $DIR/mounted.log

    echo;
    echo "We could 'docker attach' to this daemon and we'd see it's stdout but we can't take control"
    pause "Let's now lxc-attach to process"

    echo; echo "First get fullid using docker inspect"
    FULLID=`GETFULLID $ID`
    echo "ID=<$ID> FULLID=<$FULLID>"

    echo; echo "lxc-attach to container $FULLID"
    echo "Then do a 'ps -fade'"
    echo "echo;echo 'YES WERE IN!!';echo; uptime; echo; ps -fade" | sudo lxc-attach --name $FULLID

    echo; echo "Now let's lxc-attach to take control"
    echo "sudo lxc-attach --name $FULLID"
    sudo lxc-attach --name $FULLID
}

GETFULLID() {
    SHORTID=$1
    docker inspect $SHORTID | perl -ne 'if (/\"ID\": "(\S+)"/) { print $1; }'
}

TEST1() {
     DEBUG=1
     DEBUG_BANNER "Show basic container launching in interactive mode"

     #echo; pause "Starting long-lived Docker container in interactive mode:"
     #CMD="while true;do echo 'hello world'; date; sleep 1;done"
     #CMD="while true;do echo \\\`date\\\` 'hello world'; sleep 1;done"
     CMD="while true;do echo \\\$(date) 'hello world'; sleep 1;done"
     #echo E
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
     #SHOW_DOCKER run -i -t base /bin/sh -c "$CMD"
     #SHOW_DOCKER run -i -t base /bin/sh -c $CMD
     #SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
}

TEST2() {
     DEBUG=1
     DEBUG_BANNER "Show basic container launching in interactive mode"

     SHOW_THREADS
}

TEST3() {
    RMALL
    docker images | grep my/ping && {
        echo "Removing exisint 'my/ping' image";
        SHOW_DOCKER rmi my/ping;
    }


    echo "IMAGES:"
    docker images

    DOCKERFILE_EXAMPLE

    echo; pause "Now let's rerun that build"
    DOCKERFILE_EXAMPLE

    echo; pause "Now let's rerun that ping"
    SHOW_DOCKER run my/ping www.google.com
}

DEMO_UNIONFS() {
     RMALL

     echo; pause "Let's look at the Union filesystem"
     CMD='touch /tmp/hello; ls -altr /tmp/ /bin/ls; echo;echo; rm -rf /bin/; ls -altr /tmp /bin/ls'
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
     ID1=`GETLASTID`
     FID1=`GETLASTFULLID`

     echo; pause "Now let's look again"
     CMD='ls -altr /tmp/ /bin/ls'
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""
     ID2=`GETLASTID`
     FID2=`GETLASTFULLID`

     echo; pause "What happened?"
     LIST_ALL

     echo
     echo "Here are the ids of those 2 containers (docker ps -q -a -l):"
     echo "1st ID=$ID1 FULLID=$FID1"
     echo "2nd ID=$ID2 FULLID=$FID2"

     echo
     SHOW_DOCKER diff $ID1 | grep -v "^C /dev"
     echo
     SHOW_DOCKER diff $ID2 | grep -v "^C /dev"
     echo

     #sudo du -s /var/lib/docker/containers/{$FID1,$FID2}

     #echo
     #echo "sudo diff -rq /var/lib/docker/containers/{$FID1,$FID2}"
     #echo
     #sudo diff -rq /var/lib/docker/containers/{$FID1,$FID2}

     echo
     echo "We can see the differences under the aufs directories:"
     echo
     echo "sudo diff -rq /var/lib/docker/aufs/diff/{$FID1,$FID2}"
     echo
     sudo diff -rq /var/lib/docker/aufs/diff/{$FID1,$FID2}

     echo;
     pause "We can also reattach to an old container - let's try container1"
     SHOW_DOCKER start $FID1
     SHOW_DOCKER attach $FID1

     echo
     pause "Let's try container2"
     SHOW_DOCKER start $FID2
     SHOW_DOCKER attach $FID2

     echo
     LIST_ALL
     pause "Let's try container2 via lxc-attach"
     SHOW_DOCKER start $FID2
     LIST_ALL
     echo "sudo lxc-attach --name $FID2"
     sudo lxc-attach --name $FID2
     LIST_ALL
}

DOCKERFILE_EXAMPLE() {
    cat >/tmp/ex.docker <<EOF
FROM ubuntu
RUN apt-get install ping
ENTRYPOINT ["ping"]
EOF
    SHOW_DOCKER build -t my/ping - < /tmp/ex.docker
    SHOW_DOCKER images

    SHOW_DOCKER run my/ping www.google.com

    echo "PING interrupted"
}

################################################################################
## Args:

while [ ! -z "$1" ];do
    case $1 in
        -repo) startRepo; exit 0;;

        -push|-git) gitPush; exit 0;;
        -vi) viSlides; exit 0;;

        -RM) RMALL; exit 0;;
        -D|-debug) DEBUG=1;;

        -[dt][0-9]*) 
		NUM=${1#-[dt]};
		OPT=${1%%[0-9]*};
		#echo "NUM=$NUM OPT=$OPT";
		[ "$OPT" = "-d" ] && { echo "Invoking DEMO$NUM"; DEMO${NUM}; };
		[ "$OPT" = "-t" ] && { echo "Invoking TEST$NUM"; TEST${NUM}; };
		exit 0;;

        *) die "Unknown option: '$1'";;
    esac
    shift
done

exit 0

#726  docker run -i -t base /bin/sh -c 'while true;do echo "hello world";done'

