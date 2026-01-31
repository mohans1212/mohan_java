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
                                docker logout
                            '''
                            }
                }
            }
        }
        stage('Update file') {
            steps {
                sh '''
                    git clone https://github.com/mohans1212/config-repo.git || true
                    cd config-repo
                    git pull || true
                    yq e ".spec.template.spec.containers[0].image = \\"${IMAGE_TAGE}\\"" -i app/deployment.yml
                    cat app/deployment.yml
                '''
            }
        }
        stage('Commit and Push Changes') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'gitpass',
                        usernameVariable: 'GIT_USER',
                        passwordVariable: 'GIT_PASS'
                    )
                ]) {
                    sh '''
                      git config user.name "jenkins"
                      git config user.email "jenkins@ci"
                      pwd
                      cd config-repo/app/
                      git add deployment.yml
                      git commit -m "label update for build ${IMAGE_TAGE}" || echo "No changes to commit"

                      git push https://${GIT_USER}:${GIT_PASS}@github.com/mohans1212/config-repo.git main
                    '''
            }
         
          }
        }
    }

}







