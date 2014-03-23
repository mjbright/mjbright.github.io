Lightweight Virtualization with Docker
======================================

Grenoble Python User Group    -  <http://mjbright.github.io/Pygre>
----------------------------


Michael Bright, 27th March 2014.
----------------------------

---

Overview
======================================

1. What is Docker?
    + Containers versus VMs
    + What use is it?
+ Installing and Using Docker
    + Docker commands
    + The image repository
    + Building Images
    + REST API
    + Connecting containers
    + OpenStack and Docker
+ ... and finally
    + Demo
    + Links


---

Stuff
--------------------

- Structure
- Images
- Helicopter view

---

What is Docker?
========================

Docker is a container mechanism, originally developed on
LXC (Linux Containers) to allow ...

---

Containers versus VMs
========================

What is a container?
--------------------

A container isolates a set of processes on a host machine limiting
what can be done by those processes and to them.

![VM_containers](images/VM_vs_Containers.PNG)

---

What is Docker?
========================

Docker provides

1. Lightweight virtualization - no OS emulation
   Allows fast spin up times

+ A union filesystem allowing incremental 'images'

+ An image repository - private or public <https://index.docker.io/>
  accessible from command-line and REST APIs.

What does it all mean? - what it gives us
--------------------------------------------
- Low memory
- Low disk footprint
- Fast spinup
- Hierarchical images via repo

What does Docker bring that Container's don't?
----------------------------------------------
- Image repository
- Union filesystem

---

UnionFS (aufs)
=====================================

![UnionFS](images/UnionFS.PNG)

---

What use is it?
========================

In the same way that virtual machines can be used to provide isolation
and allow cloud functionality (spin up) containers systems such as
Docker can do this with much lighter processes as we do not emulate the
host OS.

Although Docker is not considered to be production ready until its
impending v1.0 release (April 2014?) it is already being integrated
into several PaaS (Platform-as-a-Service) platforms such as
RedHats OpenShift, ActiveStates Stackato and soon CloudFoundry.

Projects around Docker
----------------------

Many !!!!

---

Docker Versions
=================

- originally written in Python
- v0.7 Raspberry Pi
- v0.8
- v0.9
- v1.0

- 1 year Birthday 20 Mar 2014

Changes
----------
- Python -> Go
- LXC -> libcontainer
- OpenStack Nova Driver (Havana) -> OpenStack Heat (IceHouse)

---

Intalling Docker
=================

---

Using Docker
========================

Using Docker - Docker commands [1]
======================================

    !bash

       $ docker images # List local images
       REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
       my/ping             latest              f492632bbd55        11 hours ago        139.7 MB
       wpress              latest              93a82573c321        20 hours ago        680 MB
       ubuntu              12.04               8dbd9e392a96        11 months ago       128 MB
       base                ubuntu-12.10        b750fe79269d        12 months ago       175.3 MB

       # Run the base image and print Hello World:
       $ time docker run -i -t base /bin/echo "Hello World"
       Hello World

       real    0m0.690s # model name: Intel(R) Atom(TM) CPU  230   @ 1.60GHz

       $ docker ps -a # Show all containers
       CONTAINER ID  IMAGE  COMMAND              CREATED     STATUS  PORTS NAMES
       9d6d3c8a9a18  base   /bin/echo Hello Worl 5 mins ago  Exit 0        thirsty_hawking


---

Using Docker - Docker commands [2]
======================================

       # Run the base image as a daemon:
       $ docker run --name DAEMON1 -d base bash -c 'while true; do date; sleep 1;done'
       1e616ddb8f265063efa2abc8e2f7c728c122ccaadfa179dbe698540ff02ea75c

       $ docker ps    # Show running containers only
       CONTAINER ID  IMAGE   COMMAND               CREATED     STATUS    PORTS NAMES
       1e616ddb8f26  base    bash -c while true;   5 secs ago  Up 4 secs       DAEMON1

       # Attach to container to see stderr/stdout:
       $ docker attach 1e616ddb8f26
       Sun Mar 23 19:22:58 UTC 2014
       Sun Mar 23 19:22:59 UTC 2014

       $ pstree -ap 8324
       docker,8324 -d
         |-bash,17034 -c while true; do date; sleep 1;done
         |   `-sleep,20237 1
         |-{docker},8325
         |-{docker},8326
         |-{docker},8327
         |-{docker},8328
         |-{docker},8329
         |-{docker},8332
         |-{docker},8333
         |-{docker},8365
         |-{docker},30009
         |-{docker},17035
         |-{docker},18231
         `-{docker},18610
  

---

Using Docker - Docker commands [3]
======================================

    !bash

        docker stop $(docker ps -q)   # Stop all runnning containers
        docker rm $(docker ps -a -q)  # Remove all stopped containers

---

The image repository
========================

Creating/using a Docker private repo
--------------------------------------

![repo](images/Repository.PNG)

+ repo push/pull/tagging
+ private repo

Building Images
===============

---

Building Images - from a Docker file
===============

    Contents of minimal dockerfile:
    !bash


        FROM ubuntu
        RUN apt-get install ping
        ENTRYPOINT ["ping"]

    Building and tagging a new image:
    !bash

        $ docker build -t my/ping - < Dockerfile

        $ docker images
        REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
        my/ping             latest              f492632bbd55        12 hours ago        139.7 MB
        ubuntu              12.04               8dbd9e392a96        11 months ago       128 MB
        base                latest              b750fe79269d        12 months ago       175.3 MB

        $ docker run my/ping www.google.com
        docker run my/ping www.google.com
        PING www.google.com (173.194.67.99) 56(84) bytes of data.
        64 bytes from wi-in-f99.1e100.net (173.194.67.99): icmp_req=1 ttl=44 time=53.3 ms
        64 bytes from wi-in-f99.1e100.net (173.194.67.99): icmp_req=2 ttl=44 time=54.2 ms



---


REST API
========================

Refer to [Docker API](http://docs.docker.io/en/latest/reference/api/docker_remote_api_v1.8)

echo -e "GET /images/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock

echo -e "GET /containers/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock

echo -e "GET /containers/json?all=true HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Start:
--------
echo -e "POST /containers/<ID>/start HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Restart:
--------
echo -e "POST /containers/<ID>/restart HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Stop:
--------
echo -e "POST /containers/<ID>/stop HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Attach:
-------

echo -e "POST /containers/<ID>/attach?logs=1&stream=1&stdout=1 HTTP/1.0\r\n" | nc -U /var/run/docker.sock

---


---

Connecting containers
========================

- Ports
- Expose
- Ambassadors

---

OpenStack and Docker - in Havana (deprecated)
============================================

![havana](images/OLD_Docker_Wiki_NovaDriver_500px-Docker-under-the-hood.png)

---

OpenStack and Docker - in IceHouse
=================================

![icehouse](images/NEW_Docker_in_IceHouse_heat-nova-300x142.png)

---

... and finally
========================

---

Demo
========================

---

Links
========================

This presentation [here](http://mjbright.github.io/Pygre/2014/2014-Mar-27-LightWeightVirtualizationWithDocker/presentation.html "PyGre")

[The Docker website]<http://docker.io>

[The Docker Blog](http://blog.docker.io "The Docker Blog")

TOADD: [19 Mar 2014 e-mail](https://mail.google.com/mail/u/0/?ui=2&shva=1#inbox/144db663f35a11b0)

---



Invocation: Options
======================

-name
-------

Usage of docker:

  -D, --debug=false: Enable debug mode

  -H, --host=[]: Multiple tcp://host:port or unix://path/to/socket to bind in daemon mode, single connection otherwise. systemd socket activation can be used with fd://[socketfd].

  -G, --group="docker": Group to assign the unix socket specified by -H when running in daemon mode; use '' (the empty string) to disable setting of a group

  --api-enable-cors=false: Enable CORS headers in the remote API

  -b, --bridge="": Attach containers to a pre-existing network bridge; use 'none' to disable container networking

  --bip="": Use this CIDR notation address for the network bridge's IP, not compatible with -b

  -d, --daemon=false: Enable daemon mode

  --dns=[]: Force docker to use specific DNS servers

  -g, --graph="/var/lib/docker": Path to use as the root of the docker runtime

  --icc=true: Enable inter-container communication

  --ip="0.0.0.0": Default IP address to use when binding container ports

  --iptables=true: Disable docker's addition of iptables rules

  -p, --pidfile="/var/run/docker.pid": Path to use for daemon PID file

  -r, --restart=true: Restart previously running containers

  -s, --storage-driver="": Force the docker runtime to use a specific storage driver

  -e, --exec-driver="native": Force the docker runtime to use a specific exec driver

  -v, --version=false: Print version information and quit

  --mtu=0: Set the containers network MTU; if no value is provided: default to the default route MTU or 1500 if no default route is available



---



Demo
======================

---

Images:
======================

docker run image
  ==> base

tagging, copying images to local repo

images on disk

hierarchy of images


---


Internals:
======================

ps -fade | grep docker


Conclusions
======================


Subtitle2
---------

-
- Your first slide (title slide) should not have a heading, only `<p>`s
- Your other slides should have a heading that renders to an h1 element
- To highlight blocks of code, put !{{lang}} as the first indented line
- See the included slides.md for an example

Rendering Instructions
----------------------

- Put your markdown content in a file called `slides.md`
- Run `python render.py`
- Enjoy your newly generated `presentation.html`

---

Slide #2
========

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean magna tellus,...

Section #1
----------

Integer in dignissim ipsum. Integer pretium nulla at elit facilisis eu feugiat
velit consectetur.

Section #2
----------

Donec risus tortor, dictum sollicitudin ornare eu, egestas at purus. Cras...

---

Docker Versions
==========================
- 0.8
- 0.9
- 1.0

---

Running Docker
==========================

-> Native on Ubuntu LTS and ...
-> Poss on Fedora
-> Soon in RHEL7
-> vagrant-docker
-> CoreOS
-> vagrant-dockstack (later!)
-> boot2docker(!) - via VirtualBox

---

Demo1 - Basic interaction
==========================

- Start image
- Start image, touch file
- ReStart image, ls file -> error

Script to kill items

---


Demo2 - Daemon attach/detach
============================

---

Demo3 - Open ports
==================

- communicate between machines
- ambassadors

---

Demo4 - Example envts
==================

- twisted web server
- rails
- django

ports via ssh

---


Links - 1
=========

[The demo script](./docker_demo.sh)



---


Links - 2
=========

[Deploying Multi-Server Docker Apps with Ambassadors](http://www.centurylinklabs.com/deploying-multi-server-docker-apps-with-ambassadors/)



---

Questions?
======================================




