pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:latest
      command:
        - cat
      tty: true
      volumeMounts:
        - name: docker-config
          mountPath: /kaniko/.docker
  volumes:
    - name: docker-config
      secret:
        secretName: ecr-docker-config
"""
    }
  }

  environment {
    AWS_REGION = "us-west-2"
    ECR_REPO   = "lesson-7-ecr"
    IMAGE_TAG  = "${BUILD_NUMBER}"
    IMAGE_URI  = "431118444370.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"

    HELM_REPO_URL = "https://github.com/MykolaKushka/devops.git"
    HELM_VALUES   = "charts/django-app/values.yaml"
  }

  stages {

    stage("Checkout source") {
      steps {
        checkout scm
      }
    }

    stage("Build & Push image (Kaniko)") {
      steps {
        container("kaniko") {
          sh """
          /kaniko/executor \
            --context \$(pwd) \
            --dockerfile Dockerfile \
            --destination ${IMAGE_URI} \
            --skip-tls-verify
          """
        }
      }
    }

    stage("Update Helm values") {
      steps {
        sh """
        git clone ${HELM_REPO_URL} helm-repo
        cd helm-repo

        sed -i 's|tag:.*|tag: "${IMAGE_TAG}"|' ${HELM_VALUES}

        git config user.email "jenkins@ci.local"
        git config user.name "jenkins"

        git add ${HELM_VALUES}
        git commit -m "ci: update image tag to ${IMAGE_TAG}"
        git push origin main
        """
      }
    }
  }

  post {
    success {
      echo "CI pipeline finished successfully"
    }
  }
}
