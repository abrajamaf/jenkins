# syntax=docker/dockerfile:1
#FROM jenkins/jenkins:lts-alpine
FROM jenkins/jenkins:lts

USER root

RUN apt-get update && apt-get install -y wget net-tools tzdata curl ca-certificates gnupg lsb-release

RUN mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN groupadd -r -g 989 docker

RUN echo \
  "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian   bullseye stable" |tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt-get update && apt-get -y install docker-ce-cli docker-compose-plugin

RUN wget --no-verbose -O /tmp/apache-maven-3.8.6-bin.tar.gz https://downloads.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz

RUN tar xzf /tmp/apache-maven-3.8.6-bin.tar.gz -C /opt/

RUN ln -s  /opt/apache-maven-3.8.6 /opt/mvn

RUN ln -s /opt/mvn/bin/mvn /usr/local/bin

RUN rm /tmp/apache-maven-3.8.6-bin.tar.gz

RUN ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime

RUN chown jenkins:jenkins /opt/mvn;

RUN usermod -aG docker jenkins

ENV MAVEN_HOME=/opt/mvn

USER jenkins

