pipeline {
    agent any

    environment {
        REGISTRY = "localhost:5000" // Cambia se usi un registry remoto
        IMAGE_NAME = "my-app"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Genera un tag progressivo basato sul timestamp
                    def timestamp = new Date().format('yyyyMMddHHmmss')
                    IMAGE_TAG = "${env.IMAGE_NAME}:${timestamp}"
                    
                    // Build dell'immagine
                    sh """
                    docker build -t ${env.REGISTRY}/${IMAGE_TAG} .
                    """
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    // Push dell'immagine al registry
                    sh """
                    docker push ${env.REGISTRY}/${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
