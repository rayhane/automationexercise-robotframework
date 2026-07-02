pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Installer les dependances') {
            steps {
                bat 'pip install robotframework robotframework-seleniumlibrary'
            }
        }

        stage('Executer les tests Robot Framework') {
            steps {
                bat 'robot --outputdir results tests/'
            }
        }
    }

    post {
        always {
            step([
                $class          : 'RobotPublisher',
                outputPath      : 'results',
                outputFileName  : 'output.xml',
                reportFileName  : 'report.html',
                logFileName     : 'log.html',
                disableArchiveOutput: false,
                passThreshold   : 100,
                unstableThreshold: 0,
                otherFiles      : ''
            ])
        }
    }
}