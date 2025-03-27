pipeline {
  agent any

  stages {
    stage('Check') {
      agent {
        dockerfile {}
      }
      steps {
        sh 'pre-commit run --all-files --show-diff-on-failure'
      }
    }
  }
}
