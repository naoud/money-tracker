node('maven') {
stage 'build'
openshiftBuild(buildConfig: 'money-tracker', showBuildLogs: 'true')
stage 'deploy dev'
openshiftVerifyDeployment(deploymentConfig: 'money-tracker')
stage 'test dev'
git credentialsId: 'ned-scmsecret', url: 'https://github.com/dennisstritzke/money-tracker.git'
sh 'mvn clean package -DskipTests'
sh 'mvn failsafe:integration-test'
stage 'promot to prod'
openshiftTag(srcStream: 'money-tracker', srcTag: 'latest', destStream: 'money-tracker', destTag: 'latest', destinationNamespace: 'ned-prod')
stage 'deploy to prod'
openshiftVerifyDeployment(namespace: 'ned-prod', deploymentConfig: 'money-tracker')
openshiftScale(namespace: 'ned-prod', deploymentConfig: 'money-tracker', replicaCount: '2')
}
