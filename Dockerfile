FROM jenkins/jenkins:lts

LABEL creator="Kumar Selvam <kumar@pskumar.com>"
LABEL maintainer="Kumar Selvam <kumar@pskumar.com>"
LABEL author="Kumar Selvam"

ENV JENKINS_USER admin
ENV JENKINS_PASS admin

USER root
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade

RUN apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN curl https://get.docker.com/ > dockerinstall && chmod 777 dockerinstall && ./dockerinstall
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu eon stable" > /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update
RUN apt-get install -y docker.io containerd.io
RUN apt-get autoremove -y

RUN systemctl start docker
RUN enable docker

RUN usermod -a -G docker jenkins

USER jenkins
# Skip initial setup
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

# COPY and install the plugins 
COPY plugins.txt /usr/share/jenkins/ref/
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
