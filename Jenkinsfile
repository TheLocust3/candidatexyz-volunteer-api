pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Prepare/Checkout') {
            parallel {
                dir('common') {
                    git branch: 'master', url: 'git@github.com:TheLocust3/candidatexyz-common.git', credentialsId:'common_ssh'
                }
            }
        }

        stage('Test') {
            steps {g
                sh 'ls'
                sh './jenkins_tests.sh'
            }
        }
    }
}
