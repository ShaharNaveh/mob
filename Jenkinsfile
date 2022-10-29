pipeline {
        agent any
        environment {
                TF_IN_AUTOMATION = "true"
                TF_INPUT = "0"
                IMAGE_REPO_NAME = "websrv"
                REGISTRY_URL = "521955458751.dkr.ecr.eu-central-1.amazonaws.com"
        }
        options {
                skipStagesAfterUnstable()
        }
        stages {
                stage ('Clone repository') {
                        steps {
                                script {
                                        checkout scm
                                }
                        }
                }
                stage('create-ecr') {
                        steps {
                                withAWS(credentials: 'infra') {
                                        dir('terraform/infrastructure/') {
                                                sh 'terraform init -no-color -backend-config=production.backend -reconfigure'
                                                sh 'terraform apply -no-color -auto-approve'
                                    }
                                }
                        }
                }
                stage('Build docker image') {
                        steps {
                                script {
                                        docker_image = docker.build "${REGISTRY_URL}/${IMAGE_REPO_NAME}:latest"
                                }
                        }
                }
                stage('Push docker image to ECR') {
                        steps {
                                script {
                                        withDockerRegistry(url: 'https://521955458751.dkr.ecr.eu-central-1.amazonaws.com', credentialsId: 'ecr:eu-central-1:websrv') {
                                                docker_image.push('latest')
                                        }
                                }
                        }
                }

                stage('Deploy chart') {
                        steps {
                                withAWS(credentials: 'infra') {
                                        sh 'aws eks update-kubeconfig --region eu-central-1 --name mob'
                                        sh 'helm upgrade --install websrv ./charts/websrv/ --force --namespace=websrv --create-namespace'
                                }
                        }
                }
        }
}
