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