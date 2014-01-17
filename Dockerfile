FROM ubuntu:12.04
MAINTAINER Dieter Hsu "dieterplex@gmail.com"

# Set the env variables to non-interactive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

# Upstart and DBus have issues inside docker. Work around it
#RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

# Installing the build environment
#RUN apt-get install -y build-essential devscripts fakeroot quilt dh-make automake libdistro-info-perl less nano python-dev

RUN apt-get -qq update && apt-get -y install vim git openssh-server default-jre-headless python-pip
RUN useradd -m -d /var/lib/jenkins -s /bin/bash -p $(openssl passwd -1 changeme) jenkins && \
    su - jenkins -c 'git config --global user.email "jenkins@yourdomain.com"' && \
    su - jenkins -c 'git config --global user.name "Jenkins"'
RUN echo root:chageme | chpasswd
RUN apt-get clean && mkdir /var/run/sshd

