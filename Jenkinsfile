pipeline{
    agent any

    tools {
        maven 'mymaven'
    }

    environment {
       DOCKER_HUB = "mohancloud12/myapp"
       REGISTRY_CREDENTIALS = "dockerpass"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/mohans1212/mohan_java.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Build Docker Image') {
            steps {
                script{
                    IMAGE_TAGE = "${DOCKER_HUB}:${BUILD_NUMBER}"
                    sh "docker build -t ${IMAGE_TAGE} ."
                    env.IMAGE_TAGE = IMAGE_TAGE
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script{
                            withCredentials([usernamePassword(credentialsId: REGISTRY_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh '''
                                echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
                                docker push ${IMAGE_TAGE}
                                docker image rm ${IMAGE_TAGE} || true
                                docker logout
                            '''
                            }
                }
            }
        }
    }
}