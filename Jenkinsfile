pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'test', keyFileVariable: 'key', passphraseVariable: '', usernameVariable: '')]) {
                    sh './jenkins_tests.sh'
                }
            }
        }
    }
}
