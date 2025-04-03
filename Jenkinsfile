pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '302263074599'
        AWS_REGION = 'ap-south-1'
        IMAGE_NAME = 'your-app-name'
        ECR_REPO = 'your-ecr-repository'

        // Fetch AWS credentials from Jenkins
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/fardeenkhan6295/devpro1.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$BUILD_NUMBER .'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh 'aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com'
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh 'docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$BUILD_NUMBER'
            }
        }

        stage('Deploy to EC2') {
            steps {
                sshagent(['ec2-ssh-key']) {
                    sh '''
                    ssh -o StrictHostKeyChecking=no ubuntu@EC2-PUBLIC-IP <<EOF
                        sudo docker pull $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$BUILD_NUMBER
                        sudo docker stop myapp || true
                        sudo docker rm myapp || true
                        sudo docker run -d --name myapp -p 80:80 $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$BUILD_NUMBER
                    EOF
                    '''
                }
            }
        }

        stage('Post Deployment Validation') {
            steps {
                script {
                    def response = sh(script: "curl -s -o /dev/null -w '%{http_code}' http://EC2-PUBLIC-IP", returnStdout: true).trim()
                    if (response != '200') {
                        error("Deployment failed: App is not responding")
                    }
                }
            }
        }
    }

    post {
        always {
            emailext(
                subject: "Jenkins Build #${BUILD_NUMBER} - Status",
                body: "Build completed. Check Jenkins for details.",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }
}
