pipeline {
    agent { docker { image 'ruby' } }
    stages {
        stage('Prepare/Checkout') {
            steps {
                dir('common') {
                    git branch: 'master', url: 'git@github.com:TheLocust3/candidatexyz-common.git', credentialsId:'common_ssh'
                }

                dir('user-api') {
                    git branch: 'master', url: 'git@github.com:TheLocust3/user-api.git', credentialsId:'user_api_ssh'
                }
            }
        }

        stage('Setup') {
            steps {
                sh './setup_jenkins.sh'
            }
        }

        stage('Test') {
            steps {
                sh 'bundle exec rails test'
            }
        }
    }
}
