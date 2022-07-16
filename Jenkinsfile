@Library('github.com/releaseworks/jenkinslib') _

pipeline {
    agent { label 'worker2' }
    environment {
        registry = "998752374893.dkr.ecr.us-east-1.amazonaws.com/namita-ecr-assign2"
    }

    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/nams-github/CICD-repo.git']]])
            }
        }

    // Building Docker images
    stage('Docker Image Building') {
      steps{
        script {  
                sh 'cat dockerfile'
                sh 'docker build . -t nodejs:v1'           
        }
      }
    }

    // Uploading Docker images into AWS ECR
    stage('Pushto EC repository') {
        steps{
            script {
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 998752374893.dkr.ecr.us-east-1.amazonaws.com'
                sh 'docker tag nodejs:v1 998752374893.dkr.ecr.us-east-1.amazonaws.com/namita-ecr-assign2:nodejstag'
                sh 'docker push 998752374893.dkr.ecr.us-east-1.amazonaws.com/namita-ecr-assign2:nodejstag'
            }
        }
    }
        
    stage('Nodejs application Deployment'){
        steps{
             sshagent(credentials : ['login-server']){
              sh 'ssh -o StrictHostKeyChecking=no ubuntu@10.100.11.206 "pwd && docker system prune"'
              
              
            }
            echo "login success"
        }
    }
        
    }
}
