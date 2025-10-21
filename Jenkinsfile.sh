pipeline {
    agent any
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
        choice(name: 'action', choices: ['apply', 'destroy'], description: 'Select the action to perform')

    }
 environment {
       
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        AWS_DEFAULT_REGION    = 'ap-south-1'
    }
   stages {
     stage('checkout')
       steps {
          git branch : 'main' , url: 'https://github.com/Dhivya-ghub/terraform-demo-script.git'
       }
     stage('Terraform init')
     
