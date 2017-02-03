#!/bin/bash -ex

CI_ENVIRONMENT=$1

function create_namespace {
  kubectl get ns $1 || kubectl create ns $1
}

# deploy Deployment
if [[ "$CI_ENVIRONMENT" = "production" ]]; then
  create_namespace production
  kubectl apply --namespace=production -f k8s/${CI_ENVIRONMENT}/ --record
  kubectl apply --namespace=production -f k8s/ingress/ --record
else
  create_namespace ${CI_ENVIRONMENT}
  kubectl apply --namespace=${CI_ENVIRONMENT} -f k8s/dev/ --record
fi

# update docker image to latest
kubectl set image deployment/hello-deployment hellonode=$CI_REGISTRY_IMAGE:${CI_BUILD_TAG:-`echo $CI_BUILD_REF | head -c 8`} --namespace=${CI_ENVIRONMENT}
