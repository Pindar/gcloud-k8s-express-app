#!/bin/bash

gcloud deployment-manager deployments delete $PROJECT_DEPLOYMENT --project $PROJECT_CREATION_PROJECT
