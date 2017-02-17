#!/bin/bash

if [[ "$1" = "" ]]; then
  echo "usage specify PROJECT_ID";
  exit 1;
fi

# First argument is project id, defaults to test-gitlabci-k8s
PROJECT_ID=${1:-"test-gitlabci-k8s"}

# remove cluster
gcloud container clusters delete example-cluster -q --zone europe-west1-b

# remove service-account
gcloud iam service-accounts delete gitlab-ci-token@${PROJECT_ID}.iam.gserviceaccount.com -q

# remove iam binding to service account
gcloud projects get-iam-policy ${PROJECT_ID} --format json > policy.json
# might remove too many roles because it removes all user from a binding which has also gitlab-ci as member
cat policy.json | jq '.bindings |=  map(select(.members[] | contains("gitlab-ci-token") | not))' > policy-update.json
gcloud projects set-iam-policy ${PROJECT_ID} policy-update.json
