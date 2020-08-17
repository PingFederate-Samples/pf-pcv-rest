pipeline {
    agent {
        docker {
            image 'maven:3-alpine'
        }
    }

    environment {
        JFROG_USER = credentials("cts_jfrog_user")
        JFROG_PASS = credentials("cts_jfrog_password")
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn -s .mvn/settings.xml  -DJFROG_USER=${JFROG_USER} -DJFROG_PASS=${JFROG_PASS}  -B -DskipTests compile'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn -DskipTests package'
            }
        }
        stage('Deploy') {
            steps {
                sh 'mvn -DskipTests -s .mvn/settings.xml  -DJFROG_USER=${JFROG_USER} -DJFROG_PASS=${JFROG_PASS} deploy'
            }
        }

//         stage('Push') {
//             steps {
//                 withCredentials([[ $class: 'AmazonWebServicesCredentialsBinding', credentialsId : '0ce8798e-0c75-4357-b687-59c247908b86']]) {
// 	                sh 'aws configure set region us-east-1'
// 	            	sh 'aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID'
// 	            	sh 'aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY'
// 	            	sh '$(aws ecr get-login --no-include-email)'
// 	                sh 'mvn -e clean package dockerfile:push'
//                 }
//             }
//         }

    }
}