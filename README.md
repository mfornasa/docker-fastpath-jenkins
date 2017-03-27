# Docker FastPath - Jenkins

This repository shows how to implement [Docker FastPath](https://github.com/mfornasa/docker-fastpath) using [Jenkins](https://jenkins.io/). For an introduction to Docker FastPath, please read my [blog post](???).

The repository contains a mokcup Node.js application, but the approach is applicable to any application based on Docker and built on Jenkins.  The procedure assumes that you have an account on Docker Hub (they offer a free 1-image plan), but you can use your own private Docker registry (standalone, AWS ECR, etc.). I you prefer to use Travis CI, see the [Travis CI version](https://raw.githubusercontent.com/mfornasa/docker-fastpath-travis).


## Prerequisites
* A Docker Hub account (or an account on a private Docker registry)

## Jenkins Installation
You need a Jenkins installation with Docker. If you already have it, please skip this step. Otherwise, to test locally you can run Jenkins over Docker as follows (you need a working local Docker [installation](https://www.docker.com/community-edition#/download) and the `git` command line):

* Clone this repository on your local machine: `git clone https://github.com/mfornasa/docker-fastpath-jenkins.git`
* Move to the repository directory: `cd docker-fastpath-jenkins`
* `docker build -t jenkins-docker jenkins/` (this is going to take some time on first run)
* `docker run -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock jenkins-docker`
* Access Jenkins at http://localhost:8080
* Follow the instructions to initialize Jenkins and select the "Install suggested plugins" option.
* Create your admin user.

## Setup Docker image repository
* [Create](https://hub.docker.com/add/repository/) an image repository on Docker Hub (or on your private registry). Make sure that you create a private repository if your project is private.

## Set Docker registry credentials
* Go to `Credentials -> System -> Global Credentials (unrestricted) -> Add Credentials`
* Configure a new credential as follow:
  * `Kind: "Username with password"`
  * `Scope: "Global"`
  * `Username`: your Docker Hub username
  * `Password`: you Docker Hub pasword
  * `ID`: `dockerhub` (do not change this, it is referenced in the `Jenkinsfile`)
  * `Description`: `Docker Hub credentials`

## Configure the build
* Configure a new project, type `Pipeline`
* Configure the project parameters:
  * Select `This project is parametrized`
  * Add a `String parameter` (`Name`: `imageRepo`, `Default value`: your Docker Hub repository name, e.g.: `username/test`)
* In the `Pipeline->Definition` select `Pipeline script from SCM`
* In `Pipeline->SCM` Select `git`
* Add the repository URL (https://github.com/mfornasa/docker-fastpath-jenkins)
* Click `Save`
* Click `Build with parameters`
* Click `Build`

## Usage

Take a look at Jenkins build logs. You will see the image build process:
```
New code. Building...
...
Sending build context to Docker daemon 6.216 MB

Step 1 : FROM node:6.10.1-alpine
6.10.1-alpine: Pulling from library/node
Status: Downloaded newer image for node:6.10.1-alpine
...
```
your (placeholder) tests are happening:
```
Do some tests...
```
the image is pushed to the image repository:
```
Pushing xxxx/test:b3a9d4c658f9d228da28fedb1af39de4869ac9af to the registry
```
and your (placeholder) deploy is happening:
```
Deploy xxxx/test:b3a9d4c658f9d228da28fedb1af39de4869ac9af (placeholder)
```

To make sure that FastPath is working correctly, click `Build with parameters -> Build` again.

In this case, logs are gonna be rather different. FastPath notices that you already have an image for this codebase:

```
Found a suitable image: xxxx/test:b3a9d4c658f9d228da28fedb1af39de4869ac9af
```

and the image is deployed:
```
Deploy xxxx/test:b3a9d4c658f9d228da28fedb1af39de4869ac9af (placeholder)
```

Super-fast, and no risks of introducing untested errors in you deploy.

This is a simplified example: FastPath is going to detect every case in which the pushed codebase is identical to a codebase alredy built in the past. See this [blog post](??) for some examples.

