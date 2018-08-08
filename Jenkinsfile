pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                sh 'ruby --version'
                sh 'pwd'
                sh 'ls'
                sh './test_setup'
            }
        }
    }
}
