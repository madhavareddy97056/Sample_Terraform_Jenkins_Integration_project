pipeline {
    agent any
    tools {
        terraform "terraformcli"
    }
    stages {
        stage ("fetch code") {
            steps {
                git branch: "main", url: "https://github.com/madhavareddy97056/terraform_project.git"
            }
        }
        stage ("Initializing terraform"){
            steps {
                sh "terraform init"
            }
            post {
                success {
                    echo "Terraform initilization was Success"
                }
                failure {
                    echo "Terraform initilization was Failed"
                }
            }
        }
        stage ("validate tf files"){
            steps {
                sh "terraform validate"
            }
            post {
                success {
                    echo "Terraform validation was Success"
                }
                failure {
                    echo "Terraform valiation was Failed"
                }
            }
        }
        stage ("format tf files"){
            steps {
                sh "terraform fmt"
            }
        }
        stage ("see execution plan"){
            steps {
                sh "terraform plan"
            }
        }
        stage ("provisiong resources"){
            steps {
                sh "terraform apply --auto-approve"
            }
            post {
                success {
                    echo "Terraform apply was Success"
                }
                failure {
                    echo "Terraform apply was Failed"
                }
            }
        }
    }
}