pipeline {
    agent any
    tools {
        maven 'maven-3.6.2'
        jdk 'open-jdk8'
    }
    stages {
        stage('Check out git repo') {
            steps {
               git 'https://github.com/shobancs/spring-petclinic.git'
            }
        }
        stage('Build') {
            steps {
               sh 'mvn clean install'
            }
        }

        stage('Sonar analysis') {
            environment {
                scannerHome = tool 'SonarQubeScanner'
            }

            steps {
                withSonarQubeEnv("Sonarqube-Sever") {
                    sh "${scannerHome}/bin/sonar-scanner"
                }

           }
        }
        stage ('Artifactory configuration') {
            steps {
                rtServer (
                    id: "ARTIFACTORY_SERVER",
                    url: 'http://192.168.1.99:8081/artifactory',
                    username:'admin',
                    password:'password'
                )

                rtMavenDeployer (
                    id: "MAVEN_DEPLOYER",
                    serverId: "ARTIFACTORY_SERVER",
                    releaseRepo: "libs-release-local",
                    snapshotRepo: "libs-snapshot-local"
                )

                rtMavenResolver (
                    id: "MAVEN_RESOLVER",
                    serverId: "ARTIFACTORY_SERVER",
                    releaseRepo: "artifactory-maven-virtual",
                    snapshotRepo: "artifactory-maven-virtual"
                )
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
               sshagent(credentials : ['vagrant-user-with-key']) {
                sh 'ssh -o StrictHostKeyChecking=no vagrant@prod-host.cheekuru.com uptime'
                sh 'ssh -v vagrant@prod-host.cheekuru.com'
                sh 'scp ./target/spring-petclinic-2.1.0.BUILD-SNAPSHOT.jar vagrant@prod-host.cheekuru.com:/home/vagrant/devops/'
                sh 'ssh -o StrictHostKeyChecking=no vagrant@prod-host.cheekuru.com java -jar /home/vagrant/devops/spring-petclinic-2.1.0.BUILD-SNAPSHOT.jar'

               }
            }
        }
    }
}