#!/bin/bash

. .gitlab-env

function delete_key {
  GITLAB_API="https://gitlab.com/api/v3/projects/$GITLAB_PROJECT_ID/variables/$1"
  curl --request DELETE --header "PRIVATE-TOKEN: $GITLAB_PRIVATE_TOKEN" "$GITLAB_API"
}

delete_key "CLUSTER_NAME"
delete_key "GCLOUD_ZONE"
delete_key "DOMAIN"
delete_key "PROD_SUBDOMAIN"
delete_key "STAGING_SUBDOMAIN"
delete_key "GCLOUD_PROJECT_ID"
delete_key "DOCKER_HOST"
delete_key "GCLOUD_GITLAB_CI_SERVICE_ACCOUNT"
delete_key "GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY"
delete_key "CI_REGISTRY_IMAGE"
