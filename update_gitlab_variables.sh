#!/bin/bash

. .gitlab-env

function update_key {
  GITLAB_API="https://gitlab.com/api/v3/projects/$GITLAB_PROJECT_ID/variables/$1"
  curl --request PUT --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "$GITLAB_API" --form "value=$2"
}

if [[ "$1" = "" ]]; then
  echo "usage specify GCLOUD_PROJECT_ID";
  exit 1;
fi

GCLOUD_PROJECT_ID=${1:-"$GCLOUD_PROJECT_ID"}

# update GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY
GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY=`cat gitlab-ci-token.json | base64`
update_key "GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY" "$GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY"

# update gcloud project
CI_REGISTRY_IMAGE="eu.gcr.io/$GCLOUD_PROJECT_ID/kbnw-express-app"
update_key "CI_REGISTRY_IMAGE" "$CI_REGISTRY_IMAGE"

GCLOUD_GITLAB_CI_SERVICE_ACCOUNT="gitlab-ci-token@$GCLOUD_PROJECT_ID.iam.gserviceaccount.com"
update_key "GCLOUD_GITLAB_CI_SERVICE_ACCOUNT" "$GCLOUD_GITLAB_CI_SERVICE_ACCOUNT"

GCLOUD_PROJECT=$GCLOUD_PROJECT_ID
update_key "GCLOUD_PROJECT" "$GCLOUD_PROJECT"

update_key "CLUSTER_NAME" "$CLUSTER_NAME"
update_key "GCLOUD_ZONE" "$GCLOUD_ZONE"
update_key "DOMAIN" "$DOMAIN"
update_key "PROD_SUBDOMAIN" "$PROD_SUBDOMAIN"
update_key "STAGING_SUBDOMAIN" "$STAGING_SUBDOMAIN"
update_key "DOCKER_HOST" "$DOCKER_HOST"
