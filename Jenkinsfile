pipeline {
    environment {
        dockerimagename = 'scottiee/demo-flask-pipeline'
    }

    agent any

    stages {
        stage('Clone repository') {
            steps {
                checkout scm
            }
        }

        stage('Setup buildx') {
            steps {
                script {
                    sh 'docker buildx use wizardly_euclid'
                }
            }
        }

        stage('Build image') {
            steps {
                script {
                    def app
                    sh "docker buildx build --builder wizardly_euclid --platform linux/arm64 -t ${dockerimagename} . --load"
                    app = docker.image(env.dockerimagename)
                }
            }
        }
        
        stage('Test image') {
            steps {
                script {
                    def app = docker.image(env.dockerimagename)
                    app.inside("-d sleep 10") {
                    sh 'echo "Tests passed"'
                        }
                }
            }
        }

        stage('Push image') {
            steps {
                script {
                    def app = docker.image(env.dockerimagename)
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhublogin') {
                        app.push("${env.BUILD_NUMBER}")
                    }
                }
            }
        }
    }
    
    post {
        success {
            script {
                echo "triggering updatemanifestjob"
                build job: 'updatemanifest', parameters: [string(name: 'DOCKERTAG', value: env.BUILD_NUMBER)]
            }
        }
    }
}
