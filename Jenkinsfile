@Library('lokisharedlibs') _
pipeline {

    stages{

        stage('Checkout code'){
            steps{
                git credentialsId: 'Jenkins_Github_crd',
                url: ' https://github.com/lokeshsgithub/spring-boot-mongo-docker.git'
                sendSlackNotifications('STARTED')
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