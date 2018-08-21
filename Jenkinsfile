pipeline {
    agent {
        label 'node-36'
    }
    parameters {
         string(name: 'tomcat_dev', defaultValue: '10.74.68.133', description: 'Staging Server')
         string(name: 'tomcat_prod', defaultValue: '10.74.68.133', description: 'Production Server')
    }

    triggers {
         pollSCM('* * * * *')
     }

stages{
        stage('Build'){
            steps {
                sh 'mvn clean package'
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
                        sh "scp **/target/*.war kube@${params.tomcat_dev}:/opt/tomcat/apache-tomcat-8.5.32/webapps/"
                    }
                }

                stage ("Deploy to Production"){
                    steps {
                        sh "scp **/target/*.war kube@${params.tomcat_prod}:/opt/tomcat/apache-tomcat-8.5.32/webapps/"
                    }
                }
            }
        }
    }
}
