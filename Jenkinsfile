pipeline {
    agent { label: "docker" }

    environment {
        JFROG_USER = credentials("cts_jfrog_user")
        JFROG_PASS = credentials("cts_jfrog_password")
    }

    stages {
        stage('Version') {
            when {
                allOf {
                    branch 'master'
                }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'cycle-ghprp-auth07080b632-6420-46cf-83b5-631080ba8109', usernameVariable: 'gitUsername', passwordVariable: 'gitPassword')]) {
                    sh "export GIT_USER=$gitUsername && export GIT_PASS=$gitPassword && make push-version"
                }
            }
        }
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'cycle-ghprp-auth07080b632-6420-46cf-83b5-631080ba8109', usernameVariable: 'gitUsername', passwordVariable: 'gitPassword')]) {
                    sh "export GIT_USER=$gitUsername && export GIT_PASS=$gitPassword && make build"
                }
            }
        }
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
        stage('Deploy') {
            when {
                allOf {
                    branch 'master'
                }
            }
            steps {
                sh 'export GIT_USER=$gitUsername && export GIT_PASS=$gitPassword && make deploy'
            }
        }
    }
}