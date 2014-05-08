FROM ubuntu:12.04

# Set the env variables to non-interactive
ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_PRIORITY critical
ENV DEBCONF_NOWARNINGS yes

# Upstart and DBus have issues inside docker. Work around it
#RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

# Installing the build environment
#RUN apt-get install -y build-essential devscripts fakeroot quilt dh-make automake libdistro-info-perl less nano

#RUN echo -e 'LANG=en_US.UTF-8\nLC_ALL="en_US.UTF-8"\nLC_CTYPE="en_US.UTF-8"\nLC_NUMERIC="en_US.UTF-8"\nLC_TIME="en_US.UTF-8"\nLC_COLLATE=C\nLC_MONETARY="en_US.UTF-8"\nLC_MESSAGES="en_US.UTF-8"\nLC_PAPER="en_US.UTF-8"\nLC_NAME="en_US.UTF-8"\nLC_ADDRESS="en_US.UTF-8"\nLC_TELEPHONE="en_US.UTF-8"\nLC_MEASUREMENT="en_US.UTF-8"\nLC_IDENTIFICATION="en_US.UTF-8"\n' > /etc/default/locale && locale-gen en_US.UTF-8 && dpkg-reconfigure locales

# Trick to Install fuse(openjdk7 dependency) because of container permission issue.
#RUN apt-get -y install fuse || true
#RUN rm -rf /var/lib/dpkg/info/fuse.postinst
#RUN apt-get -y install fuse
#RUN apt-get install -y openjdk-7-jdk

RUN echo deb http://10.90.0.86/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list \
    && apt-get -qq update \
    && apt-get -y install vim git openssh-server default-jre-headless python-pip


# Add jenkins user
RUN useradd -m -d /var/lib/jenkins -s /bin/bash -p $(openssl passwd -1 password) jenkins && \
    su - jenkins -c 'git config --global user.email "jenkins@tw.promise.com"' && \
    su - jenkins -c 'git config --global user.name "Jenkins (Cloud Storage)"'
# Fix root passwd
RUN echo root:promise | chpasswd

RUN apt-get install -y build-essential python-dev
RUN apt-get clean && mkdir /var/run/sshd
ADD id_rsa_jenkins /root/.ssh/id_rsa
RUN chmod go-rwx -R /root/.ssh
RUN mkdir /root/.m2 ; \
    echo "<settings><mirrors><mirror>\n<mirrorOf>*</mirrorOf><url>http://10.90.0.93:8081/artifactory/repo</url><id>artifactory</id>\n</mirror></mirrors></settings>" > /root/.m2/settings.xml

# ENV APACHE_RUN_USER www-data
# ENV APACHE_RUN_GROUP www-data
# ENV APACHE_LOG_DIR /var/log/apache2
# EXPOSE 80
# EXPOSE 22
# ADD ./startup.sh /opt/startup.sh
# ENTRYPOINT ["/opt/startup.sh"]
