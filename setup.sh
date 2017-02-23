#!/bin/bash

# environment variables or arguments
GCLOUD_PROJECT_ID=${1:-"$GCLOUD_PROJECT_ID"}
GITLAB_PROJECT_ID=${2:-"$GITLAB_PROJECT_ID"}
GITLAB_CI_RUNNER_TOKEN=${3:-"$GITLAB_CI_RUNNER_TOKEN"}

# setup google cloud project and wait around 5 minutes for getting ready
./k8s/gcp/setup_gcloud_project.sh $GCLOUD_PROJECT_ID
sleep 300

# create cluster and service account
./k8s/gcp/setup_gcloud_resources.sh $GCLOUD_PROJECT_ID
# making all variables available at the gitlab ci step
./create_gitlab_variables.sh $GCLOUD_PROJECT_ID $GITLAB_PROJECT_ID
# setup gitlab ci runner
./k8s/gitlab-ci-runner/setup_gitlab_ci_runner.sh $GITLAB_CI_RUNNER_TOKEN
