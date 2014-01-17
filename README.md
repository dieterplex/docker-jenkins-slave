This Dockerfile provide a Jenkins slave image for [Docker plugin](https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin).

Install Docker
--------------

See http://docs.docker.io/en/latest/installation/ubuntulinux/


Install docker plugin
---------------------

From http://<Jenkins>:8080/pluginManager/available install Docker and Credentials Plugins

See https://wiki.jenkins-ci.org/display/JENKINS/Docker+Plugin


Add Docker option
-----------------

Here assume you are install docker alone with jenkins server.

    echo DOCKER_OPTS="-H=tcp://127.0.0.1:4243" >> /etc/default/docker
    service docker restart


Setup Jenkins
-------------

Go to Jenkins configure page

Add a new cloud: Docker

Set 'Docker URL': `http://127.0.0.1:4243/`

Default Credentials: `root/changeme`, `jenkins/changeme`
