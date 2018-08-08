pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                sh './jenkins_tests.sh'
            }
        }
    }
}
