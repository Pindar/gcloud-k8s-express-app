#!/bin/bash

if [[ "$1" = "" ]]; then
  echo "usage specify PROJECT_ID";
  exit 1;
fi

# First argument is project id, defaults to test-gitlabci-k8s
PROJECT_ID=${1:-"test-gitlabci-k8s"}
# Second argument is billing account id, defaults to an account which is marked as "Mein Rechnungskonto"
ACCOUNT_ID=${2:-`gcloud alpha billing accounts list | grep "Mein Rechnungskonto" |  awk '{ print $1 }'`}


gcloud projects describe $PROJECT_ID --format json
if [[ $? -eq 0 ]]; then
  # cluster exists already, check status.
  # if cluster is already active do nothing
  [[ `gcloud projects describe $PROJECT_ID --format json | jq -r '.lifecycleState'` == "ACTIVE" ]] && echo "project is active" && exit 0
  [[ `gcloud projects describe $PROJECT_ID --format json | jq -r '.lifecycleState'` == "DELETE_REQUESTED" ]] && gcloud projects undelete $PROJECT_ID
else
  # create a new project
  gcloud alpha projects create $PROJECT_ID
fi


# enable billing for this new project
gcloud alpha billing accounts projects link $PROJECT_ID --account-id=$ACCOUNT_ID
gcloud config set core/project $PROJECT_ID

# wait until Compute Engine is initialized for this project
#sleep 2m
