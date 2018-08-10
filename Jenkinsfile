pipeline {
    agent {
        docker {
            image 'ruby'
        }
    }
    environment {
        PGUSER     = 'test'
        PGPASSWORD = credentials('db_password')
        PGHOST     = 'jenkins.cc5npzmk75z5.us-east-1.rds.amazonaws.com'
        PGPORT     = '5432'
        AWS_REGION = 'us-east-1'
    }

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

    post {
        always {
            junit 'test/reports/*.xml'
        }
    }
}
