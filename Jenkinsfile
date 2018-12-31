/**
*/
node {
  echo sh(script: 'env|sort', returnStdout: true)
  checkout scm
  docker.image('generalmeow/jenkins-tools:1.7')
        .inside('--network host -v /home/paul/work/docker/docker-maven-repo:/root/.m2/repository') {

    pom = readMavenPom file: 'pom.xml'
    def pomVersion = pom.version
    def projectName = 'reborn-service-discovery'
    def dockerRegistry = 'localhost:5000'

    stage ('Initialize') {
      //sh '''
      //'''
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
    stage('Deploy jar to nexus') {
      echo 'Deploying Jar to Nexus....'
      sh 'mvn deploy -DskipTests'
    }
    stage('Build and Publish Docker Image') {
      echo 'downloading artifacts from nexus....'

      sh 'mkdir -p ./downloads'
      //server.download(downloadSpec)
      def downloadUrl = "http://tinker.paulhoang.com:8081/repository/maven-releases/com/paulhoang/${projectName}/${pomVersion}/${projectName}-${pomVersion}.jar"
      echo 'downloading from "${downloadUrl}"'
      sh 'curl -o ./downloads/app.jar ' + downloadUrl
      echo 'Download complete'

      echo "Building docker image.... generalmeow/${projectName}"
      def dockerImage = docker.build("generalmeow/${projectName}:${env.BUILD_ID}", ".")

      echo 'Pushing Docker Image....'
      docker.withRegistry('https://registry.hub.docker.com', 'generalmeow-dockerhub'){
        dockerImage.push()
      }
    }
    stage('Deploy to k8s') {
          def deploymentExists = sh "kubectl get deployments ${projectName} --no-headers | wc -l"
          sh 'kubectl apply -f k8/reborn-service-discovery-deployment.yaml --record'
          sh 'kubectl apply -f k8/reborn-service-discovery-svc.yaml --record'
          sh 'kubectl apply -f k8/reborn-service-discovery-ingress.yaml --record'
        }
    /*
    stage('Package and push helm chart') {
      sh 'cd reborn-service-discovery-chart'
      sh 'helm package .'
    }
    stage('Deploy to k8s dev') {
      echo 'Deploying Chart....'
    }
    */
  }
}
