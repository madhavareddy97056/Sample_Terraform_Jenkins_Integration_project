pipeline {
    agent any
    tools {
        terraform "terraformtool"
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
             post {
                success {
                    echo "Terraform plan was Success"
                }
                failure {
                    echo "Terraform plan was Failed"
                }
            }
        }
        /*stage ("provisiong resources"){
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
        }*/
        stage ("Destroying resources"){
            steps {
                sh "terraform destroy --auto-approve"
            }
            post {
                success {
                    echo "Terraform destroy was Success"
                }
                failure {
                    echo "Terraform destroy was Failed"
                }
            }
        } 
    }
}
