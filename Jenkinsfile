pipeline {
agent any

```
stages {

    stage('Clone Repository') {
        steps {
            checkout scmGit(
                branches: [[name: '*/master']],
                userRemoteConfigs: [[
                    credentialsId: 'aniktagit',
                    url: 'https://github.com/2000ankitareddy/java-project-maven-new.git'
                ]]
            )
        }
    }

    stage('Build with Maven') {
        steps {
            sh 'mvn clean install'
        }
    }

    stage('Stop Old Container') {
        steps {
            sh '''
            docker stop java-container || true
            docker rm java-container || true
            '''
        }
    }

    stage('Remove Old Image') {
        steps {
            sh 'docker rmi java-maven-app || true'
        }
    }

    stage('Build Docker Image') {
        steps {
            sh 'docker build -t java-maven-app .'
        }
    }

    stage('Run Docker Container') {
        steps {
            sh 'docker run -d -p 8033:8080 --name java-container java-maven-app'
        }
    }

}

post {
    always {
        cleanWs()
    }
}
```

}
