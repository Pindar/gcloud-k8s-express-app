#!/bin/bash -x

if [[ "$1" = "" ]]; then
  echo "usage specify PROJECT_ID";
  exit 1;
fi

# First argument is project id, defaults to test-gitlabci-k8s
PROJECT_ID=${1:-"test-gitlabci-k8s"}

# create and configure cluster
gcloud container clusters create example-cluster --zone europe-west1-b
gcloud container clusters get-credentials example-cluster --zone europe-west1-b

# create service account
gcloud iam service-accounts create gitlab-ci-token --display-name "Account is used to deploy to Kubernetes from Gitlab CI"

# create key, we need this one to get gitlab-ci working
gcloud iam service-accounts keys create "$(pwd)/gitlab-ci-token.json" --iam-account gitlab-ci-token@${PROJECT_ID}.iam.gserviceaccount.com


# applay iam roles
# Docker registry: https://cloud.google.com/container-registry/docs/access-control
# Conatiner Cluster https://cloud.google.com/container-engine/docs/iam-integration
PERMISSION_TPL='.bindings |= .+ [{
  "members": [
    "serviceAccount:gitlab-ci-token@%PROJECT_ID%.iam.gserviceaccount.com"
  ],
  "role": "roles/container.developer"
}, {
  "members": [
    "serviceAccount:gitlab-ci-token@%PROJECT_ID%.iam.gserviceaccount.com"
  ],
  "role": "roles/storage.admin"
}, {
  "members": [
    "serviceAccount:gitlab-ci-token@%PROJECT_ID%.iam.gserviceaccount.com"
  ],
  "role": "roles/storage.objectCreator"
}, {
  "members": [
    "serviceAccount:gitlab-ci-token@%PROJECT_ID%.iam.gserviceaccount.com"
  ],
  "role": "roles/storage.objectViewer"
}]'

PERMISSION=`echo $PERMISSION_TPL | sed "s/%PROJECT_ID%/$PROJECT_ID/g"`

gcloud projects get-iam-policy ${PROJECT_ID} --format json > policy.json
cat policy.json | jq "$PERMISSION" > policy-update.json
gcloud projects set-iam-policy ${PROJECT_ID} policy-update.json
