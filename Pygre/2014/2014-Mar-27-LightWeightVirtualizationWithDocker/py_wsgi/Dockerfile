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

