pipeline {
agent any

```
stages {

    stage('Clone Repository') {
        steps {
            checkout scmGit(
                branches: [[name: '*/master']],
                extensions: [],
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

    stage('Build Docker Image') {
        steps {
            sh 'docker build -t java-maven-app .'
        }
    }

    stage('Run Docker Container') {
        steps {
            sh '''
            docker rm -f java-container || true
            docker run -d -p 8080:8080 --name java-container java-maven-app
            '''
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
