pipeline {

  environment {
    dockerimagename = "hackersmooth88/dotnetlinux"
    dockerImage = "hackersmooth88/dotnetlinux"
  }

  agent any

  stages {

    stage('Checkout Source') {
      steps {
        sh 'rm -rf /var/jenkins_home/workspace/development/*'
        sh 'git clone -q https://github.com/h4ckersmooth88/sample-asp.git'
        echo 'pwd'
          
      }
    }

    stage('Build image') {
      steps{
        script {
          sh 'docker build -t hackersmooth88/dotnetlinux /var/jenkins_home/workspace/development/sample-asp/.'
        }
      }
    }

    stage('Pushing Image') {
      environment {
               registryCredential = 'dockerhub-credentials'
           }
      steps{
        script {
            sh 'cat ~/my_password.txt | docker login --username hackersmooth88 --password-stdin'
            sh 'docker push hackersmooth88/dotnetlinux:latest'
          
        }
      }
    }

    stage('Deploying App to Kubernetes') {
      steps {
        script {
          sh 'kubectl create namespace development'
          sh 'kubectl apply -f /var/jenkins_home/workspace/coba/sample-asp/deployment.yaml'
          sh 'kubectl apply -f /var/jenkins_home/workspace/coba/sample-asp/service.yaml'
        }
      }
    }

  }

}
