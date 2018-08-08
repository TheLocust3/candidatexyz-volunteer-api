pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'common_ssh', keyFileVariable: 'SSH_KEY', passphraseVariable: '', usernameVariable: 'SSH_NAME')]) {
                    sh './jenkins_tests.sh'
                }
            }
        }
    }
}
