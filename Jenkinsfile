pipeline {
    agent any
    tools {
        maven 'Maven-3.6.0'
        jdk 'java-11-openjdk'
    }
    stages {
        stage('Check out git repo') {
            steps {
               git 'https://github.com/shobancs/spring-petclinic.git'
            }
        }
        stage ('Artifactory configuration') {
            steps {
                rtServer (
                    id: "ARTIFACTORY_SERVER",
                    url: 'http://artifactory.cheekuru.com:8081/artifactory',
                    username:'admin',
                    password:'Admin230'
                )

                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "ARTIFACTORY_SERVER",
                    releaseRepo: "spring-petclinic-release",
                    snapshotRepo: "spring-petclinic-snapshot"
                )

                rtMavenResolver (
                    id: "MAVEN_RESOLVER",
                    serverId: "ARTIFACTORY_SERVER",
                    releaseRepo: "spring-petclinic-virtual-groups",
                    snapshotRepo: "spring-petclinic-virtual-groups"
                )
            }
        }
        stage('Build') {
            steps {
               sh 'mvn clean install'
            }
        }

        stage('Sonar analysis') {
            environment {
                scannerHome = tool 'sonarqube-scanner-4.4'
            }

            steps {
                withSonarQubeEnv("mysonar-server") {
                    sh "${scannerHome}/bin/sonar-scanner"
                }

           }
        }
        

        stage('Upload to artifactory') {
            steps {
                rtPublishBuildInfo (
                    serverId: "ARTIFACTORY_SERVER"
                )
            }
        }
         stage('Deploy to production') {
            steps {
                echo "Deploy Spring petclinic"
               //sshagent(credentials : ['vagrant-user-with-key']) {
                   
                //sh 'ssh -o StrictHostKeyChecking=no vagrant@prod-host.cheekuru.com uptime'
                //sh 'ssh -v vagrant@prod-host.cheekuru.com'
                //sh 'scp ./target/spring-petclinic-2.1.0.BUILD-SNAPSHOT.jar vagrant@prod-host.cheekuru.com:/home/vagrant/devops/'
                //sh 'ssh -o StrictHostKeyChecking=no vagrant@prod-host.cheekuru.com java -jar /home/vagrant/devops/spring-petclinic-2.1.0.BUILD-SNAPSHOT.jar'

               //}
            }
        }
    }
}
