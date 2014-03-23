Lightweight Virtualization with Docker
======================================

- Michael Bright, 27 Mars 2014.

---

Lightweight Virtualization with Docker
======================================

- Overview: What's a container?
- OpenStack and Docker
- OpenStack versus Vagrant ??

[docker.io](http://docker.io)

TOADD: [19 Mar 2014 e-mail](https://mail.google.com/mail/u/0/?ui=2&shva=1#inbox/144db663f35a11b0)

---

What's a container?
--------------------

- LXC: Linux Containers

Intalling Docker
=================

Docker Versions
=================

- v0.7 Raspberry Pi
- v0.8
- v0.9
- v1.0

- 1year Birthday !! Mar 2014

What's Docker?
===============

- A wrapper around LXC

What does Docker bring that Container's don't?
----------------------------------------------
- Image repository
- Union filesystem

What's bad?
-----------
- 
- Union filesystem

Changes
==========
- Python -> Go
- LXC -> ...
- OpenStack Nova Driver (Havana) -> OpenStack Heat (IceHouse)

What else?
==========

- Ports
- Ambassadors

What does it all mean? - what it gives us
==========================================
- Low memory
- Low disk footprint
- Fast spinup
- Hierarchical images via repo

Projects around Docker
======================

Many !!!!
- ....

Docker and OpenStack
======================

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


Demo
======================

Images:
======================

docker run image
  ==> base

tagging, copying images to local repo

images on disk

hierarchy of images



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

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean magna tellus,
fermentum nec venenatis nec, dapibus id metus. Phasellus nulla massa, consequat
nec tempor et, elementum viverra est. Duis sed nisl in eros adipiscing tempor.

Section #1
----------

Integer in dignissim ipsum. Integer pretium nulla at elit facilisis eu feugiat
velit consectetur.

Section #2
----------

Donec risus tortor, dictum sollicitudin ornare eu, egestas at purus. Cras
consequat lacus vitae lectus faucibus et molestie nisl gravida. Donec tempor,
tortor in varius vestibulum, mi odio laoreet magna, in hendrerit nibh neque eu
eros.

Docker Versions
==========================
- 0.8
- 0.9
- 1.0

Running Docker
==========================

-> Native on Ubuntu LTS and ...
-> Poss on Fedora
-> Soon in RHEL7
-> vagrant-docker
-> CoreOS
-> vagrant-dockstack (later!)
-> boot2docker(!) - via VirtualBox

Demo1 - Basic interaction
==========================

- Start image
- Start image, touch file
- ReStart image, ls file -> error

Script to kill items


Demo2 - Daemon attach/detach
============================

Demo3 - Open ports
==================

- communicate between machines
- ambassadors

Demo4 - Example envts
==================

- twisted web server
- rails
- django

ports via ssh


Links - 1
=========

[The demo script](./docker_demo.sh)

Links - 2
=========

[Deploying Multi-Server Docker Apps with Ambassadors](http://www.centurylinklabs.com/deploying-multi-server-docker-apps-with-ambassadors/)


Questions?
======================================



