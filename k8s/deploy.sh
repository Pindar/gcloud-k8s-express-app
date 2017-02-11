#!/bin/bash -ex

CI_ENVIRONMENT=$1

function create_namespace {
  kubectl get ns $1 || kubectl create ns $1
}

# set domains
sed -i.bak 's#STAGING_DOMAIN#$STAGING_SUBDOMAIN.$DOMAIN#' k8s/ingress/*.yaml
sed -i.bak 's#PRODUCTION_DOMAIN#$PROD_SUBDOMAIN.$DOMAIN#' k8s/ingress/*.yaml


# deploy Deployment
if [[ "$CI_ENVIRONMENT" = "production" || "$CI_ENVIRONMENT" = "staging" ]]; then
  create_namespace production
  # update docker image to latest
  sed -i.bak 's#IMAGE_PLACEHOLDER#$CI_REGISTRY_IMAGE:${CI_BUILD_TAG:-`echo $CI_BUILD_REF | head -c 8`}#' k8s/${CI_ENVIRONMENT}/*.yaml
  # apply changes and create/update ingress
  kubectl apply --namespace=production -f k8s/${CI_ENVIRONMENT}/ --record
  kubectl apply --namespace=production -f k8s/ingress/ --record

else
  create_namespace ${CI_ENVIRONMENT}
  # update docker image to latest
  sed -i.bak 's#IMAGE_PLACEHOLDER#$CI_REGISTRY_IMAGE:${CI_BUILD_TAG:-`echo $CI_BUILD_REF | head -c 8`}#' k8s/dev/*.yaml
  # apply changes
  kubectl apply --namespace=${CI_ENVIRONMENT} -f k8s/dev/ --record
fi
