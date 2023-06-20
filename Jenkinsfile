@Library('lokisharedlibs') _
pipeline {
    agent any

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