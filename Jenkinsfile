pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'test', keyFileVariable: 'SSH_KEY', passphraseVariable: '', usernameVariable: 'SSH_NAME')]) {
                    sh 'ls'
                    sh 'env'
                    sh './jenkins_tests.sh'
                }
            }
        }
    }
}
