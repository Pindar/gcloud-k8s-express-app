#!/bin/bash

# https://cloudplatform.googleblog.com/2017/04/automating-project-creation-with-Google-Cloud-Deployment-Manager.html?m=1
# gcloud deployment-manager deployments create <newproject_deployment> --config config.yaml --project <Project Creation project>
gcloud deployment-manager deployments create $PROJECT_DEPLOYMENT --config config.yaml --project $PROJECT_CREATION_PROJECT
