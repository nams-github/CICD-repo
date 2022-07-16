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
             sh ''' cd /home/ubuntu
             pwd
             sshagent(credentials : ['login-server']){
              sh 'ssh -o StrictHostKeyChecking=no ubuntu@10.100.11.206 "sudo docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 998752374893.dkr.ecr.us-east-1.amazonaws.com/namita-ecr-assign2 && sudo docker pull 998752374893.dkr.ecr.us-east-1.amazonaws.com/namita-ecr-assign2:nodejstag && (sudo docker ps -f name=node -q | xargs --no-run-if-empty sudo docker container stop) && (sudo docker container ls -a -fname=node -q | xargs -r sudo docker container rm) && sudo docker run -d -p 8081:8081 --rm --name node 998752374893.dkr.ecr.us-east-1.amazonaws.com/namita-ecr-assign2"' 
            }
        }
    }
        
    }
}
