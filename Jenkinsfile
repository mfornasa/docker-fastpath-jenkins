node {
  checkout scm
  def REPO = params.imageRepo
  def GIT_COMMIT = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
  def DEPLOY_TAG = "$REPO:$GIT_COMMIT"
  def FAST_PATH = ''

  stage('Fastpath') {
    sh 'wget https://docker-fastpath.s3-eu-west-1.amazonaws.com/releases/linux/docker-fastpath-linux-amd64-latest.tgz'
    sh 'tar xzvf docker-fastpath-linux-amd64-latest.tgz'
    sh 'rm docker-fastpath-linux-amd64-latest.tgz'

    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub',
        usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
      FAST_PATH = sh(script: "./fastpath --verbose HEAD $REPO", returnStdout: true).trim()
    }
  }

  stage('Build') {
    if (FAST_PATH == '') {
      echo "New code. Building..."
      sh "docker build -t $DEPLOY_TAG ."
    } else {
      DEPLOY_TAG = "$REPO:$FAST_PATH"
      echo "Found a suitable image: $DEPLOY_TAG"
    }
  }

  stage('Test') {
    if (FAST_PATH == '') {
      echo 'Do some tests...'
    }
  }

  stage('Push') {
    if (FAST_PATH == '') {
      echo "Pushing $DEPLOY_TAG to the registry"
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 'dockerhub',
            usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD']]) {
          sh 'docker login -u="$DOCKER_USERNAME" -p="$DOCKER_PASSWORD"'
          sh "docker push $DEPLOY_TAG"
        }
    }
  }

  stage('Deploy') {
    echo "Deploy $DEPLOY_TAG (placeholder)"
  }
}
