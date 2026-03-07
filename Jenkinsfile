pipeline {
    agent any
    
    environment {
        DOCKER_HUB_USERNAME = "ankitanallamilli"                    // Your Docker Hub username
        DOCKER_IMAGE_NAME   = "${DOCKER_HUB_USERNAME}/project1" // Full image name: ankithDockHub/project1
        DOCKER_CRED_ID      = "dockerhub-credentials"            // Your Jenkins credential ID for Docker Hub
        DOCKER_TAG          = "${env.BUILD_NUMBER}"              // Tag with Jenkins build number
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }
        
        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'  // Build JAR; remove -DskipTests if tests kavali
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build using your existing Dockerfile in repo root
                    dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_TAG}")
                    
                    // Also tag as 'latest' for convenience
                    dockerImage.tag('latest')
                }
            }
        }
        
        stage('Push to Docker Hub') {
            steps {
                script {
                    // Login to Docker Hub using Jenkins credentials and push
                    docker.withRegistry('https://index.docker.io/v1/', DOCKER_CRED_ID) {
                        dockerImage.push("${DOCKER_TAG}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        
        // Optional: Run the container on Jenkins agent for quick verification
        stage('Run Container - Test') {
            steps {
                sh '''
                    docker stop myapp || true
                    docker rm myapp || true
                    docker run -d --name myapp -p 8033:8033 ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}
                '''
                echo "Docker container started!"
                echo "Test your app at: http://localhost:8033  (or Jenkins server IP:8033)"
                echo "Check logs: docker logs myapp"
            }
        }
    }
    
    post {
        always {
            cleanWs()  // Clean workspace
            sh 'docker image prune -f || true'  // Remove dangling images to save space
        }
        success {
            echo "🎉 Docker image built and pushed successfully!"
            echo "Image: ${DOCKER_IMAGE_NAME}:${DOCKER_TAG}  and :latest"
            echo "View on Docker Hub: https://hub.docker.com/r/${DOCKER_IMAGE_NAME}"
        }
        failure {
            echo "Pipeline failed 😞 — Check console logs for Maven/Docker errors"
        }
    }
}
