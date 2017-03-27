FROM jenkinsci/jenkins:lts

USER root

RUN apt-get update \
  && apt-get install -y apt-transport-https ca-certificates software-properties-common \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  && apt-get update \
  && apt-get install -y docker-ce

RUN usermod -a -G staff,docker jenkins

USER jenkins

