pipeline {
    agent any

    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'us-east-2'
        EC2_KEY = credentials('ec2-key-pem')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Dhivya-ghub/terraform-demo-script.git'
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Apply / Destroy') {
            when {
                anyOf {
                    expression { params.autoApprove }
                    expression { params.action == 'destroy' }
                }
            }
            steps {
                script {
                    if (params.action == 'apply') {
                        sh 'terraform apply -auto-approve tfplan'
                    } else if (params.action == 'destroy') {
                        sh 'terraform destroy -auto-approve'
                    }
                }
            }
        }
    }
}
