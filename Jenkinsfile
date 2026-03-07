pipeline {
    agent any
    
    tools {
        // Maven auto-install if configured in Global Tool Configuration, or direct path
        maven 'Maven'  // Change to your Maven tool name in Jenkins → Manage Jenkins → Global Tool Configuration
        jdk 'JDK17'    // Optional: if you have JDK configured
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm  // Already from git, but safe
            }
        }
        
        stage('Build') {
            steps {
                sh 'mvn clean package'  // or bat 'mvn clean package' on Windows agents
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'  // Publish test results if tests exist
                }
            }
        }
        
        // Optional: Archive the JAR
        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }
    
    post {
        always {
            cleanWs()  // Optional: clean workspace after build
        }
        success {
            echo 'Build successful! 🎉'
        }
        failure {
            echo 'Build failed 😞'
        }
    }
}
