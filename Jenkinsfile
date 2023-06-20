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
                withSonarQubeEnv(credentialsId: 'sonar_auth') {
                  sh "mvn clean package sonar:sonar"
                }
            }
        }

        stage('Sonar Quality gates') {
            steps{

                waitForQualityGate abortPipeline: false, credentialsId: 'sonar_auth'
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