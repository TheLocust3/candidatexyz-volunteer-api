pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Test') {
            steps {
                checkout([
                    $class: 'GitSCM', branches: [[name: '*/master']],
                    userRemoteConfigs: [[url: 'git@github.com:TheLocust3/candidatexyz-common.git'], [credentialsId:'common_ssh']]
                ])

                sh 'ls'
                sh 'echo test'
                sh 'ls ../'
                sh './jenkins_tests.sh'
            }
        }
    }
}
