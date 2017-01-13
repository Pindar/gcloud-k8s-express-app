#!/bin/bash -ex

PROJECT_ID=test-gitlabci-k8s

gcloud projects delete $PROJECT_ID
