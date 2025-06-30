pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'akshat122001/webapp'
        PROD_SERVER = 'your-production-server-ip'
    }
    stages {
        stage('Build') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }
        stage('Test') {
            steps {
                script {
                    docker.image("${DOCKER_IMAGE}:${env.BUILD_ID}").inside {
                        sh 'curl -I http://localhost || exit 1'
                    }
                }
            }
        }
        stage('Deploy') {
            when { branch 'master' }
            steps {
                script {
                    sshagent(['prod-server-creds']) {
                        sh """
                        ssh -o StrictHostKeyChecking=no root@${PROD_SERVER} \
                        "docker pull ${DOCKER_IMAGE}:${env.BUILD_ID} && \
                        docker-compose -f /opt/webapp/docker-compose.yml up -d"
                        """
                    }
                }
            }
        }
    }
}
