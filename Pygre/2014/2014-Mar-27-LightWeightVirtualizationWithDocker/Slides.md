Lightweight Virtualization with Docker
======================================

Grenoble Python User Group
<http://mjbright.github.io/Pygre>

Michael Bright, 27 Mars 2014.

---

# Code Sample

Landslide supports code snippets

    !bash

       docker ps    # Show running containers only
       docker ps -a # Show all containers
       docker ps -a 'hello world' # Show all containers


    !python

    def log(self, message, level='notice'):
    if self.logger and not callable(self.logger):
	raise ValueError(u"Invalid logger set, must be a callable")

    if self.verbose and self.logger:
	self.logger(message, level)

[html5slides]: http://code.google.com/p/html5slides/
[sample]: http://adamzap.com/misc/presentation.html



---

  !bash

       docker ps -a

#!/bin/bash
   ls

#!bash
   ls

#!/usr/bin/python
   import modules

:::python
   import modules

:::bash
       docker ps -a


---

Lightweight Virtualization with Docker
======================================

- Overview: What's a container?
- OpenStack and Docker
- OpenStack versus Vagrant ??

<http://docker.io>

[Docker Blog](http://blog.docker.io "The Docker Blog")

TOADD: [19 Mar 2014 e-mail](https://mail.google.com/mail/u/0/?ui=2&shva=1#inbox/144db663f35a11b0)

---

Stuff
--------------------

- Structure
- Images
- Helicopter view
- 

---

What's a container?
--------------------

- LXC: Linux Containers

![VM_containers](images/VM_vs_Containers.PNG)

---

UnionFS (aufs)
=====================================

![UnionFS](images/UnionFS.PNG)

---

Intalling Docker
=================

On what?

---

Docker Versions
=================

- v0.7 Raspberry Pi
- v0.8
- v0.9
- v1.0

- 1year Birthday !! Mar 2014

---

What's Docker?
===============

- A wrapper around LXC

What does Docker bring that Container's don't?
----------------------------------------------
- Image repository
- Union filesystem

---

What's bad?
-----------
- 
- Union filesystem

---

Changes
==========
- Python -> Go
- LXC -> ...
- OpenStack Nova Driver (Havana) -> OpenStack Heat (IceHouse)

---

What else?
==========

- Ports
- Ambassadors

---

What does it all mean? - what it gives us
==========================================
- Low memory
- Low disk footprint
- Fast spinup
- Hierarchical images via repo

---

Projects around Docker
======================

Many !!!!
- ....

---

Docker and OpenStack in Havana (deprecated)
============================================

![havana](images/OLD_Docker_Wiki_NovaDriver_500px-Docker-under-the-hood.png)

---

Docker and OpenStack in IceHouse
=================================

![icehouse](images/NEW_Docker_in_IceHouse_heat-nova-300x142.png)

---

Creating/using a Docker private repo
=====================================

![repo](images/Repository.PNG)

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

Using the REST API:
======================

Refer to [Docker API](http://docs.docker.io/en/latest/reference/api/docker_remote_api_v1.8)

echo -e "GET /images/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock

echo -e "GET /containers/json HTTP/1.0\r\n" | nc -U /var/run/docker.sock

echo -e "GET /containers/json?all=true HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Start:
--------
echo -e "POST /containers/03e1b160134bd66af9e3ce53fa67112f2f19baf88e24ddd2eee7803f384568a5/start HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Restart:
--------
echo -e "POST /containers/03e1b160134bd66af9e3ce53fa67112f2f19baf88e24ddd2eee7803f384568a5/restart HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Stop:
--------
echo -e "POST /containers/03e1b160134bd66af9e3ce53fa67112f2f19baf88e24ddd2eee7803f384568a5/stop HTTP/1.0\r\n" | nc -U /var/run/docker.sock

Attach:
-------

echo -e "POST /containers/03e1b160134bd66af9e3ce53fa67112f2f19baf88e24ddd2eee7803f384568a5/attach?logs=1&stream=1&stdout=1 HTTP/1.0\r\n" | nc -U /var/run/docker.sock

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




