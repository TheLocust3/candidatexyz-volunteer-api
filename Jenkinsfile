pipeline {
    agent { docker { image 'ruby' } }
    environment {
        GITHUB_KEY = credentials('test')
    }
    stages {
        stage('Test') {
            steps {
                sh 'env'
                sh './jenkins_tests.sh'
            }
        }
    }
}
