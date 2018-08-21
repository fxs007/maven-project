pipeline {
    agent {
        label 'node-36'
    }
    parameters {
         string(name: 'ip_dev', defaultValue: '10.74.68.133', description: 'Staging Server')
         string(name: 'ip_prod', defaultValue: '10.74.68.133', description: 'Production Server')
         string(name: 'user_dev', defaultValue: 'kube', description: 'User of Staging Server')
         string(name: 'user_prod', defaultValue: 'kube', description: 'User of Production Server')
    }

    triggers {
         pollSCM('* * * * *')
     }

stages{
        stage('Build'){
            steps {
                sh 'mvn clean package'
                sh 'docker build . -t tomcatwebapp:${env.BUILD_ID}'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }

        stage ('Deployments'){
            parallel{
                stage ('Deploy to Staging'){
                    steps {
                                         //provision ssh key in advance
                        sh "pwd && id && scp **/target/*.war ${params.user_dev}@${params.ip_dev}:/opt/tomcat/apache-tomcat-8.5.32/webapps/"
                    }
                }

                stage ("Deploy to Production"){
                    steps {
                        sh "scp **/target/*.war ${params.user_prod}@${params.ip_prod}:/opt/tomcat/apache-tomcat-8.5.32/webapps/"
                    }
                }
            }
        }
    }
}
