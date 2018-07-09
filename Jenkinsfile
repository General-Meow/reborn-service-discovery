/**
*/
node {
  echo sh(script: 'env|sort', returnStdout: true)
  checkout scm
  docker.image('generalmeow/jenkins-tools:1.4-arm')
        .inside('-v /home/paul/work/docker/docker-maven-repo:/root/.m2/repository') {

    stage ('Initialize') {
      sh '''
      '''
    }
    stage('Static analysis') {
      echo 'Running static analysis tools..'
      // sh 'mvn clean verify -P check -DskipTests'
    }
    stage('Build') {
      echo 'Building..'
      sh 'mvn clean compile'
    }
    stage('Test') {
      echo 'Testing..'
      sh 'mvn test'
    }
    stage('Maven Install') {
      echo 'Installing artifact locally'
      sh 'mvn install -DskipTests'
    }
    stage('Deploy jar to artifactory') {
      echo 'Deploying Jar to Artifactory....'
      sh 'mvn deploy -DskipTests'
    }
    stage('Build and Publish Docker Image') {
      echo 'downloading artifacts from artifactory....'
      pom = readMavenPom file: 'pom.xml'

      def pomVersion = pom.version
      def server = Artifactory.newServer url: 'http://tinker.paulhoang.com:8081/artifactory', credentialsId: 'artifactory'
      def downloadSpec = """{
       "files": [
        {
            "pattern": "libs-release-local/com/paulhoang/reborn-service-discovery/${pomVersion}/reborn-service-discovery-${pomVersion}.jar",
            "target": "downloads/app.jar"
          }
       ]
      }"""
      sh 'mkdir -p ./downloads'
      server.download(downloadSpec)
      echo 'Download comeplete'

      echo 'Building docker image....'
      def dockerImage = docker.build("generalmeow/reborn-service-discovery:${env.BUILD_ID}", "--build-arg APP_VERSION=${pomVersion} .")

      echo 'Pushing Docker Image....'
      docker.withRegistry('https://registry.hub.docker.com', 'hub.docker'){
        dockerImage.push()
      }
    }
    stage('Deploy Docker Image') {
      echo 'Deploying Docker Image....'
    }
  }
}