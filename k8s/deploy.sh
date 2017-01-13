#!/bin/bash -ex

CI_ENVIRONMENT=$1

# Create namespace if it doesn't exist
kubectl get ns ${CI_ENVIRONMENT} || kubectl create ns ${CI_ENVIRONMENT}
# deploy service
kubectl apply --namespace=${CI_ENVIRONMENT} -f k8s/services/ --record

# deploy Deployment
if [[ "$CI_ENVIRONMENT" = "production" || "$CI_ENVIRONMENT" = "staging"  ]]; then
  kubectl apply --namespace=${CI_ENVIRONMENT} -f k8s/${CI_ENVIRONMENT}/ --record
else
  kubectl apply --namespace=${CI_ENVIRONMENT} -f k8s/dev/ --record
fi

# update docker image to latest
kubectl set image deployment/hello-deployment hellonode=$CI_REGISTRY_IMAGE:${CI_BUILD_TAG:-`echo $CI_BUILD_REF | head -c 8`} --namespace=${CI_ENVIRONMENT}
