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
    #landslide -r -c Slides.md
    landslide -r ./slides.cfg
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
        echo; echo "Pushing script changes to mjbright/Tools:"
        cp $0 $GIT_SCRIPT_DIR/;
        cd $GIT_SCRIPT_DIR/;
        git commit -m "Semi-auto push: Updated script++" -a;

	set -x;
        git push ssh://git@github.com/mjbright/Tools;
	set +x;
    }

    echo; echo "Pushing script/presentation changes to mjbright.github.io:"
    cp $0 $GIT_PRES_DIR/
    cd $GIT_PRES_DIR
    git commit -m "Semi-auto push: Updated script++" -a

    #git config --get remote.origin.url
    #git remote show origin
    #git remote add origin ssh://git@github.com/mjbright/mjbright.github.io
        #git push
    set -x;
        git push ssh://git@github.com/mjbright/mjbright.github.io
    set +x;
    #git push
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

# Remove only stopped containers:
RM() {
    RUNNING_DOCKER_IDS=`docker ps -q`
    DOCKER_IDS=`docker ps -q -a`

    # Do it this way to avoid error message for running ids:
    _IDS=""
    for ID in $DOCKER_IDS;do
        [ "${RUNNING_DOCKER_IDS##*$ID}" = "$RUNNING_DOCKER_IDS" ] &&
            _IDS="$_IDS $ID"
    done

    #echo "\$DOCKER_IDS='$DOCKER_IDS'"
    #echo "\$_IDS='$_IDS'"
    docker rm $_IDS
}

# Remove running and stopped containers:
RMALL() {
    #RUNNING_DOCKER_IDS=`docker ps | awk '!/^CONTAINER/ { print $1; }'`
    #DOCKER_IDS=`docker ps -a | awk '!/^CONTAINER/ { print $1; }'`
    RUNNING_DOCKER_IDS=`docker ps -q`
    DOCKER_IDS=`docker ps -q -a`
    echo "Stopping/Removing all containers";

    [ ! -z "$RUNNING_DOCKER_IDS" ] && {
        DEBUG "Stopping running containers";
        SHOW_DOCKER stop $DOCKER_IDS;
    }

    [ -z "$DOCKER_IDS" ] && {
        echo "No Docker containers";
        return 1;
    }

    #docker rm $(docker ps -a -q)

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
     BANNER "Show basic container launching in interactive mode"

     echo; pause "Removing any existing docker containers:"
     RMALL
     LIST_ALL
     pause

     echo; pause "List all local Docker images"
     SHOW_DOCKER images

     IMAGE1=`docker images | head -2 | tail -1 | awk '{print $1;}'`
     echo; pause "Show history of first local Docker image [$IMAGE1]"
     docker history $IMAGE1

     echo; pause "Starting Docker container in interactive mode: 'hello world'"
     SHOW_DOCKER run --name HelloWorld_`dtime` -i -t base echo 'hello world'

     echo; pause "Let's look at current Docker containers"
     LIST_ALL

     echo; pause "Cleaning out container"
     RMALL

     echo; pause "Starting long-lived Docker container in interactive mode:"
     #CMD="while true;do echo 'hello world'; date; sleep 1;done"
     #CMD="while true;do echo \`date\` 'hello world'; sleep 1;done"
     CMD="while true;do echo \\\$(date) 'hello world'; sleep 5;done"
     SHOW_DOCKER run -i -t base /bin/sh -c "\"$CMD\""

}

DEMO2() {
     BANNER "Show daemon container launching"
     RMALL

     NAME=DAEMON`dtime`

     echo; pause "About to start container as daemon"
     #CMD="while true;do let LOOP=LOOP+1; echo \\\$LOOP:'STDERR' >&2; echo \\\$(date) 'hello world'; sleep 1;done"
     CMD="while true;do let LOOP=LOOP+1; echo \\\$LOOP: \\\$(date) 'hello world'; sleep 5;done"
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
     ## echo; pause "Now let's tail that log file [last 2 lines]"
     ## sudo tail -2 $LOG

     echo; pause "Now let's tail that log file"
     sudo tail -f $LOG

     #echo; echo "sleep 2"
     #sleep 2
     #echo
     #sudo ls -altr $LOG
     #sudo tail -1 $LOG

     pause "Daemon is running, now let's attach to it's stdout"
     SHOW_DOCKER attach $NAME
}

DEMO3() {
    BANNER "Run daemon whilst mounting /var/log of container to $DIR"
    RMALL
    MOUNT_DIR
}

DEMO4() {
    SETUP_WORDPRESS
}

DEMO5() {
    DEMO_UNIONFS
}

DEMO6() {

    #DEBUG_BANNER "Show pushing to repository"
    BANNER "Show pushing to repository"
    RMALL

    docker LOGIN

    echo; pause "Let's search the registry for mjbright"
    SHOW_DOCKER search mjbright

    echo; pause "About to startup our local ping image"
    SHOW_DOCKER run --name PING -d my/ping www.google.com

    echo; pause "About to attach to the new container"
    SHOW_DOCKER attach PING

    echo; pause "About to commit the container to an image called mjbright/ping"
    SHOW_DOCKER commit PING mjbright/ping
    SHOW_DOCKER images

    echo; pause "About to push the image mjbright/ping to the registry"
    SHOW_DOCKER push mjbright/ping

    echo; pause "Let's look at the history (see those ids)"
    SHOW_DOCKER history mjbright/ping

    echo; pause "Let's search the registry for mjbright"
    SHOW_DOCKER search mjbright
}

SETUP_WORDPRESS() {
    BANNER "Demonstrate building from a dockerfile"

    DOCKERFILE=/tmp/wordpress.dockerfile
    YES=""
    YES="-y"
    cat > $DOCKERFILE <<"EOF"
FROM ubuntu
#FROM base
RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe > /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y mysql-server mysql-client
RUN DEBIAN_FRONTEND=noninteractive apt-get -y apache2 apache2-mpm-prefork apache2-utils apache2.2-common libapache2-mod-php5 libapr1 libaprutil1 libdbd-mysql-perl libdbi-perl libnet-daemon-perl libplrpc-perl libpq5 mysql-common php5-common php5-mysql
RUN DEBIAN_FRONTEND=noninteractive apt-get -y vim wget net-tools
RUN wget http://wordpress.org/latest.tar.gz && mv latest.tar.gz /var/www
RUN /etc/init.d/apache2 start
EXPOSE 80
EOF

    echo
    echo
    echo "DOCKERFILE CONTENTS:"
    more $DOCKERFILE
    echo; pause "About to launch build:"

    echo "docker build -t wpress - < $DOCKERFILE"
    docker build -t wpress - < $DOCKERFILE

    #echo "docker run wpress -d -p 80:80"
    #echo "docker run -d -p 80:80 wpress /bin/bash"
    #docker run -d -p 80:80 wpress /bin/bash
    echo "docker run -i -t -p 80:80 wpress /bin/bash"
    docker run -i -t -p 80:80 wpress /bin/bash
    #"/etc/init.d/apache2 start" | sudo lxc-attach --name $FULLID
    ID=wpress
    FULLID=`GETFULLID $ID`
    #echo "/etc/init.d/apache2 start" | sudo lxc-attach --name $FULLID
    echo "/etc/init.d/apache2 start" | docker-attach --name $FULLID
    echo "PERFORM /etc/init.d/apache2 start"
    ATTACH $ID

    wget localhost:80
}

ATTACH() {
    echo "docker attach $1"
    echo "Press <return> to get prompt"
    docker attach $1
}

DEMO7() {

    BANNER "Demo creation of a mysql image, then run as a container"

    _TMP=/tmp/mysql.docker
    [ ! -d $_TMP ] && mkdir -p $_TMP

    _USER=mjbright

    cd $_TMP

    cat > run.sh <<"EOF"
#!/bin/bash
if [ ! -f /.mysql_admin_created ]; then
        /create_mysql_admin_user.sh
fi
exec supervisord -n
EOF

    cat > start.sh <<"EOF"
#!/bin/bash
exec mysqld_safe

EOF

   cat > supervisord-mysqld.conf <<"EOF"
[program:mysqld]
command=/start.sh
numprocs=1
autostart=true
EOF

    cat > Dockerfile <<"EOF"
FROM ubuntu:saucy
MAINTAINER Fernando Mayo <fernando@tutum.co>

# Install packages
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install supervisor mysql-server pwgen

# Add image configuration and scripts
ADD start.sh /start.sh
ADD run.sh /run.sh
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD import_sql.sh /import_sql.sh
RUN chmod 755 /*.sh

EXPOSE 3306
CMD ["/run.sh"]
EOF

    cat > my.cnf <<"EOF"
[mysqld]
bind-address=0.0.0.0
EOF

cat > create_db.sh <<"EOF"
#!/bin/bash

if [[ $# -eq 0 ]]; then
        echo "Usage: $0 <db_name>"
        exit 1
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

echo "=> Creating database $1"
RET=1
while [[ RET -ne 0 ]]; do
        sleep 5
        mysql -uroot -e "CREATE DATABASE $1"
        RET=$?
done

mysqladmin -uroot shutdown

echo "=> Done!"
EOF

cat > create_mysql_admin_user.sh <<"EOF"
#!/bin/bash

if [ -f /.mysql_admin_created ]; then
        echo "MySQL 'admin' user already created!"
        exit 0
fi

/usr/bin/mysqld_safe > /dev/null 2>&1 &

PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${MYSQL_PASS} ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_word} password"
RET=1
while [[ RET -ne 0 ]]; do
        sleep 5
        mysql -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
        RET=$?
done

mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"

mysqladmin -uroot shutdown

echo "=> Done!"
touch /.mysql_admin_created

echo "========================================================================"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uadmin -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"
EOF

cat > import_sql.sh <<"EOF"
#!/bin/bash

if [[ $# -ne 2 ]]; then
        echo "Usage: $0 <password> </path/to/sql_file.sql>"
        exit 1
fi

echo "=> Starting MySQL Server"
/usr/bin/mysqld_safe > /dev/null 2>&1 &
sleep 5
echo "   Started with PID $!"

echo "=> Importing SQL file"
mysql -uroot -p"$1" < "$2"

echo "=> Stopping MySQL Server"
mysqladmin -uroot -p"$1" shutdown

echo "=> Done!"
EOF

    echo; pause "About to build mysql image"
    SHOW_DOCKER build -t $_USER/mysql .
    
    echo; pause "About to run container (as daemon) from mysql image"
    #SHOW_DOCKER run -d --name mysql $_USER/mysql
    SHOW_DOCKER run -d --name mysql $_USER/mysql

    # Pickup id of our mysql container:
    MYSQL_ID=$(docker ps -q -l)

    echo; pause "About to run linked container to show DB env"
    SHOW_DOCKER run --link mysql:db ubuntu env

    echo; pause "Getting password from container logs [daemon stdout]";
    MDP=`docker logs ${MYSQL_ID} 2>/dev/null | perl -ne 'if (/mysql -uadmin -p(\S+)/) { print $1; }'`
    echo "admin password is $MDP"

    echo; pause "Getting host/port info from container environment"
    HOST_PORT=$(docker run --link mysql:db ubuntu bash -c 'echo ${DB_PORT#tcp://}')
    HOST=${HOST_PORT%:*}
    PORT=${HOST_PORT#*:}
    echo "HOST=$HOST PORT=$PORT"
    echo; pause "echo 'show databases;' | mysql -uadmin -p$MDP -h$HOST -P$PORT"
    echo
    echo "show databases;" | mysql -uadmin -p$MDP -h$HOST -P$PORT
}

DEMO8() {
    BANNER "Demo creation of a Python WSGI image, then run as a container"

    _TMP=/tmp/py_wsgi.docker
    [ ! -d $_TMP ] && mkdir -p $_TMP

    _USER=mjbright

    cd $_TMP

    cat > requirements.txt << "EOF"
flask
cherrypy
EOF

    cat > app.py << "EOF"
from flask import Flask

app = Flask(__name__)

@app.route("/")

def hello():
    return "Hello World!"

if (__name__) == "__main__":
    app.run()
EOF

    cat > server.py << "EOF"
# Import your application as:
# from app import application
# Example:

from app import app

# Import CherryPy
import cherrypy

if __name__ == '__main__':

    # Mount the application
    cherrypy.tree.graft(app, "/")

    # Unsubscribe the default server
    cherrypy.server.unsubscribe()

    # Instantiate a new server object
    server = cherrypy._cpserver.Server()

    # Configure the server object
    server.socket_host = "0.0.0.0"
    server.socket_port = 80
    server.thread_pool = 30

    # For SSL Support
    # server.ssl_module            = 'pyopenssl'
    # server.ssl_certificate       = 'ssl/certificate.crt'
    # server.ssl_private_key       = 'ssl/private.key'
    # server.ssl_certificate_chain = 'ssl/bundle.crt'

    # Subscribe this server
    server.subscribe()

    # Start the server engine (Option 1 *and* 2)

    cherrypy.engine.start()
    cherrypy.engine.block()
EOF

    cat > Dockerfile << "EOF"
FROM ubuntu:saucy
MAINTAINER Michael Bright <dockerfun@mjbright.net>

RUN echo "deb http://archive.ubuntu.com/ubuntu/ raring main universe" >> /etc/apt/sources.list
RUN apt-get update

# Install packages
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install tar git curl vim wget dialog net-tools build-essential

# Add Python stuff
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python python-dev python-distribute python-pip

RUN pip install flask
RUN pip install cherrypy

RUN mkdir -p /py_wsgi
RUN cd /py_wsgi

ADD app.py /py_wsgi/app.py
ADD server.py /py_wsgi/server.py
ADD requirements.txt /py_wsgi/requirements.txt
RUN chmod 755 /py_wsgi/*.py

RUN pip install -r /py_wsgi/requirements.txt

EXPOSE 80

WORKDIR  /py_wsgi

CMD python server.py

EOF

    echo; pause "About to build py_wsgi image"
    SHOW_DOCKER build -t $_USER/py_wsgi .

    echo; pause "About to run py_wsgi image"
    SHOW_DOCKER run -p 80:80 -i -t $_USER/py_wsgi
}

DEMO10() {
    BANNER "Inspecting images"

    CNT=mysql

    echo; pause "Let's look at the history of mjbright/$CNT"
    SHOW_DOCKER history mjbright/$CNT

    echo; pause "Inspecting processes $CNT"
    SHOW_DOCKER top $CNT

    echo; pause "Inspecting $CNT"
    SHOW_DOCKER inspect $CNT

    echo; pause "Inspecting $CNT => get ip address"
    set -x
    docker inspect $CNT | grep IPAddress | cut -d '"' -f 4
    docker inspect $CNT | jq -r '.[0].NetworkSettings.IPAddress'
    set +x

    echo; pause "Look at all images hierarchy"
    set -x
    docker images -v | dot -Tpng -o docker.png
    set +x

    #echo "Now look at http://localhost:8080"
    #python -m SimpleHTTPServer 8080

}

DEMO9() {
    BANNER "Demo creation of a Python twistd image, then run as a container"

    _TMP=/tmp/py_twistd.docker
    [ ! -d $_TMP ] && mkdir -p $_TMP

    _USER=mjbright

    cd $_TMP

    cat > Dockerfile << "EOF"
FROM base

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install telnet python python-twisted-web

CMD twistd web --path=./ --port=9000

EXPOSE 9000

EOF

    SHOW_DOCKER build -t mjbright/twistd .

    SHOW_DOCKER run -p 9000:9000 -i -t mjbright/twistd
}


MOUNT_DIR() {
    DIR=/var/myapp/log
    LOG=$DIR/mounted.log

    [ ! -d $DIR ] && sudo mkdir -p $DIR
    sudo chown $USER $DIR
    [ -f $LOG ] && rm -f $LOG

    #CMD="while true;do sleep 1; date >> /var/log/mounted.log; done"
    CMD="while true;do let LOOP=LOOP+1; date >> /var/log/mounted.log; echo OK\$LOOP; sleep 5;done"
    echo; pause "About to launch $CMD"
    ID=`set -x;docker run --name MNT_EXAMPLE -v $DIR:/var/log -d -t base /bin/bash -c "$CMD"`

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

LOGIN() {
    [ -z "$MDP" ] && read -s -p "MDP> " MDP
    [ -z "$MDP" ] && die "Please set MDP variable"

    #docker login
    docker login -u mjbright -p $MDP -e docker@mjbright.net
}

TEST4() {
    LOGIN
    #set -x
    #set +x
}

DEMO_UNIONFS() {
     BANNER "Union Filesystem"
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

     ## echo
     ## echo "We can see the differences under the aufs directories:"
     ## echo
     ## echo "sudo diff -rq /var/lib/docker/aufs/diff/{$FID1,$FID2}"
     ## echo
     ## sudo diff -rq /var/lib/docker/aufs/diff/{$FID1,$FID2}

     echo;
     pause "We can also reattach to an old container - let's try container1 (will FAIL)"
     SHOW_DOCKER start $FID1
     SHOW_DOCKER attach $FID1

     echo
     pause "Let's try container2"
     SHOW_DOCKER start $FID2
     SHOW_DOCKER attach $FID2

     ## echo
     ## LIST_ALL
     ## pause "Let's try container2 via lxc-attach"
     ## SHOW_DOCKER start $FID2
     ## LIST_ALL
     ## echo "sudo lxc-attach --name $FID2"
     ## sudo lxc-attach --name $FID2
     ## LIST_ALL
}

DOCKERFILE_EXAMPLE() {
    # http://stackoverflow.com/questions/19585028/docker-i-lose-my-data-when-the-container-exits
    cat >/tmp/ex.docker <<EOF
FROM ubuntu
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install ping
#RUN apt-get install ping
ENTRYPOINT ["ping"]
EOF
    SHOW_DOCKER build -t my/ping - < /tmp/ex.docker
    SHOW_DOCKER images

    SHOW_DOCKER run my/ping www.google.com

    echo "PING interrupted"
}

createMarkdown() {
    die "TODO"
}

################################################################################
## Args:

while [ ! -z "$1" ];do
    case $1 in
        -repo) startRepo; exit 0;;

        -push|-git) gitPush; exit 0;;
        -vi) vi $0; exit 0;;
        -vis*) viSlides; exit 0;;

        -RM) RM; exit 0;;
        -RMA) RMALL; exit 0;;
        -RMI) echo "Removing '<none>' images";
              docker rmi $(docker images | grep none |awk '{print $3;}');
              exit 0;;

        -D|-debug) DEBUG=1;;

        -md) 
            createMarkdown ;;

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

