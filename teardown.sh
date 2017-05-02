#!/bin/bash

GCLOUD_PROJECT_ID=${1:-"$GCLOUD_PROJECT_ID"}

# tear down gitlab ci
./k8s/gitlab-ci-runner/tear_down_gitlab_ci_runner.sh
./delete_gitlab_variables.sh

# tear down cluster resources
./k8s/teardown.sh

# taer down of all google cloud resources for K8s takes a little bit of time.
# to have no left over we need to give it some time.
sleep 60

# delete gcloud resources
./gcp/tear_down_gcloud_resources.sh

# last missing step
# ./k8s/gcp/tear_down_gcloud_project.sh $GCLOUD_PROJECT_ID
