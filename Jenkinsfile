pipeline {
    agent any
    environment {
        SONARQUBE = 'sonar'  // Name of the SonarQube server you configured in Jenkins
        SONAR_SCANNER = 'SonarQubeScanner'  // Name of the SonarQube Scanner tool in Jenkins
        IMAGE_NAME = 'my-app-image'  // Name of the Docker image
        CONTAINER_NAME = 'my-app-container'  // Name of the Docker container
    }
    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/rajk68501/devsec.git', branch: 'main'
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image if SonarQube analysis is successful
                    sh 'docker build -t $IMAGE_NAME .'
                }
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv(SONARQUBE) {
                        // Run SonarQube analysis
                        def sonarResult = sh(script: """
                            ${tool SONAR_SCANNER}/bin/sonar-scanner \
                            -Dsonar.projectKey=my-project-key \
                            -Dsonar.projectName=my-project-name \
                            -Dsonar.sources=.
                        """, returnStatus: true)

                        // Check if SonarQube analysis was successful
                        if (sonarResult != 0) {
                            currentBuild.result = 'FAILURE'
                            error "SonarQube analysis failed."
                        }
                    }
                }
            }
        }

        stage('Run Docker Container') {
            when {
                expression {
                    return currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                script {
                    // Run the Docker container with your application only if SonarQube passed
                    sh 'docker run -d -p 80:80 --name $CONTAINER_NAME $IMAGE_NAME'
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up Docker resources after the build
                sh 'docker system prune -f'
            }
        }
    }
}
