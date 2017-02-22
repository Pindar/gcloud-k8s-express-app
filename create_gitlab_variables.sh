#!/bin/bash

. .gitlab-env

function create_key {
  GITLAB_API="https://gitlab.com/api/v3/projects/$GITLAB_PROJECT_ID/variables"
  curl --request POST --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "$GITLAB_API" --form "key=$1" --form "value=$2"
}

GCLOUD_PROJECT_ID=${1:-"$GCLOUD_PROJECT_ID"}

if [[ "$GCLOUD_PROJECT_ID" = "" ]]; then
  echo "usage specify GCLOUD_PROJECT_ID";
  exit 1;
fi

GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY=`cat gitlab-ci-token.json | base64`
create_key "GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY" "$GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY"

CI_REGISTRY_IMAGE="eu.gcr.io/$GCLOUD_PROJECT_ID/kbnw-express-app"
create_key "CI_REGISTRY_IMAGE" "$CI_REGISTRY_IMAGE"

GCLOUD_GITLAB_CI_SERVICE_ACCOUNT="gitlab-ci-token@$GCLOUD_PROJECT_ID.iam.gserviceaccount.com"
create_key "GCLOUD_GITLAB_CI_SERVICE_ACCOUNT" "$GCLOUD_GITLAB_CI_SERVICE_ACCOUNT"

GCLOUD_PROJECT=$GCLOUD_PROJECT_ID
create_key "GCLOUD_PROJECT" "$GCLOUD_PROJECT"

create_key "CLUSTER_NAME" "$CLUSTER_NAME"
create_key "GCLOUD_ZONE" "$GCLOUD_ZONE"
create_key "DOMAIN" "$DOMAIN"
create_key "PROD_SUBDOMAIN" "$PROD_SUBDOMAIN"
create_key "STAGING_SUBDOMAIN" "$STAGING_SUBDOMAIN"
create_key "DOCKER_HOST" "$DOCKER_HOST"
