pipeline {
    agent any

    environment {
        AWS_REGION = 'ap-south-1'   // set your region
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }

        stage('Install Tools') {
            steps {
                echo "Installing Checkov and Prowler..."
                sh '''
                    sudo yum install -y python3 git
                    pip3 install --upgrade pip
                    pip3 install checkov
                    git clone https://github.com/prowler-cloud/prowler.git || true
                '''
            }
        }

        stage('Run Checkov Scan') {
            steps {
                echo "Running Checkov..."
                sh '''
                    checkov -d . --quiet || echo "Checkov scan completed with findings."
                '''
            }
        }

        stage('Run Prowler Scan') {
            steps {
                echo "Running Prowler AWS security check..."
                sh '''
                    cd prowler
                    ./prowler -M json -S || echo "Prowler scan completed with findings."
                '''
            }
        }

        stage('Post Results') {
            steps {
                echo "All scans completed!"
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully."
        }
        failure {
            echo "Pipeline failed. Please check logs."
        }
    }
}
