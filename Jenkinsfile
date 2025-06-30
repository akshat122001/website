pipeline {
    agent any
    environment {
        DOCKER_IMAGE = 'akshat122001/webapp'
        BUILD_ID = "${env.BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            environment {
                DOCKER_BUILDKIT = "1"  # Enable modern Docker builds
            }
            steps {
                script {
                    if (!fileExists('Dockerfile')) {
                        error("Dockerfile not found in repository root!")
                    }
                    docker.build("${DOCKER_IMAGE}:${BUILD_ID}")
                }
            }
        }
        
        stage('Test') {
            steps {
                script {
                    // Start container with proper port mapping
                    sh """
                        docker run -d --name test-container -p 8080:80 ${DOCKER_IMAGE}:${BUILD_ID}
                        sleep 10  # Wait for Apache to start
                    """
                    
                    // Test the running container
                    sh """
                        curl -I http://localhost:8080 || exit 1
                    """
                    
                    // Cleanup
                    sh """
                        docker stop test-container
                        docker rm test-container
                    """
                }
            }
        }
        
        stage('Deploy') {
            when { 
                branch 'master' 
            }
            steps {
                script {
                    sshagent(['prod-server-creds']) {
                        sh """
                            ssh -o StrictHostKeyChecking=no root@your_production_server_ip "
                                docker pull ${DOCKER_IMAGE}:${BUILD_ID}
                                docker stop webapp || true
                                docker rm webapp || true
                                docker run -d --name webapp -p 80:80 ${DOCKER_IMAGE}:${BUILD_ID}
                            "
                        """
                    }
                }
            }
        }
    }
    post {
        failure {
            slackSend channel: '#devops',
                     message: "❌ FAILED: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
        success {
            slackSend channel: '#devops',
                     message: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
    }
}
