pipeline {
    agent {
        label 'node-36'
    }
    parameters {
         string(name: 'tomcat_ip_dev', defaultValue: '10.74.68.133', description: 'Staging Server')
         string(name: 'tomcat_ip_prod', defaultValue: '10.74.68.133', description: 'Production Server')
         string(name: 'tomcat_user_dev', defaultValue: 'kube', description: 'User of Staging Server')
         string(name: 'tomcat_user_prod', defaultValue: 'kube', description: 'User of Production Server')
    }

    triggers {
         pollSCM('* * * * *')
     }

stages{
        stage('Build'){
            steps {
                sh 'mvn clean package'
                //sh 'env && pwd && id'
                sh "docker build . -t tomcatwebapp:${env.BUILD_ID}"
                // docker push
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
                        sh "scp **/target/*.war ${params.tomcat_user_dev}@${params.tomcat_ip_dev}:/opt/tomcat/apache-tomcat-8.5.32/webapps/"
                    }
                }

                stage ("Deploy to Production"){
                    steps {
                        sh "scp **/target/*.war ${params.tomcat_user_prod}@${params.tomcat_ip_prod}:/opt/tomcat/apache-tomcat-8.5.32/webapps/"
                    }
                }
            }
        }
    }
}
