@Library('lokisharedlibs') _
pipeline {
    agent any

    tools {
        maven 'maven3.9.0'
    }

    stages{

        stage('Checkout code'){
            steps{
                sendSlackNotifications('STARTED')
                git credentialsId: 'Jenkins_Github_crd',
                url: ' https://github.com/lokeshsgithub/spring-boot-mongo-docker.git'
                
            }
        }

        stage('Unit Testing') {
            steps{
                sh "mvn test"
            }
        }

        stage('Integrate maven test cases') {
            steps{
                sh "mvn verify -DskipUnitTests"
            }
        }

        stage('Build & sonarqube analysis') {
            steps{
                withSonarQubeEnv(credentialsId: 'sonar_auth',installationName: 'sonarqube') {
                  sh "mvn clean package sonar:sonar"
                }
            }
        }

        stage('Sonar Quality gates') {
            steps{

                waitForQualityGate abortPipeline: false, credentialsId: 'sonar_auth'
            }
        }

        /*stage('Uploading the artifact into nexus') {
            steps{
                nexusArtifactUploader artifacts:
                 [
                    [
                        artifactId: 'spring-boot-starter-parent',
                        classifier: '',
                        file: 'target/*.jar',
                        type: 'jar'
                    ]
                ],
                credentialsId: 'Nexus_crd',
                groupId: 'org.springframework.boot',
                nexusUrl: '3.111.40.43:8081',
                nexusVersion: 'nexus3',
                protocol: 'http',
                repository: 'springapp-release',
                version: '2.1.5.'
            }
        }*/

        stage('Docker Build image') {
            steps{
                sh "docker image build -t $JOB_NAME/$BUILD_TAG ."
                sh "docker image tag $JOB_NAME/$BUILD_TAG lokeshsdockerhub/$JOB_NAME:$BUILD_TAG"
                sh "docker image tag $JOB_NAME/$BUILD_TAG lokeshsdockerhub/$JOB_NAME:latest"
                
            }
        }

        stage('Push the image into dockerhub') {
            steps{
                script{
                    """
                     withCredentials([string(credentialsId: 'dockerhub_auth', variable: 'dockerhub_pwd')]) {
                        docker login -u lokeshsdockerhub --password ${dockerhub_pwd}
                        docker push lokeshsdockerhub/$JOB_NAME:$BUILD_TAG
                        docker push lokeshsdockerhub/$JOB_NAME:latest
                     }
                    """
                }
            }
        }
    }
    post {
        success{
            sendSlackNotifications(currentBuild.result)
        }
        failure{
            sendSlackNotifications(currentBuild.result)
        }
    }
}