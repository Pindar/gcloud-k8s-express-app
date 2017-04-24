#!/bin/bash

gcloud deployment-manager deployments create res-gke --config infrastructure.yaml --project $PROJECT_NAME
