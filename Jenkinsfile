pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                sh 'ruby --version'
                sh './jenkins_tests.sh'
            }
        }
    }
}
