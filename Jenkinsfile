pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Hello i am fardeen'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build('my-docker-image:latest', '.')
                }
            }
        }
    }
}