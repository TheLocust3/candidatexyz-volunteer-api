pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'test', keyFileVariable: 'KEY', passphraseVariable: '', usernameVariable: '')]) {
                    sh 'ls'
                    sh 'env'
                    sh './jenkins_tests.sh'
                }
            }
        }
    }
}
