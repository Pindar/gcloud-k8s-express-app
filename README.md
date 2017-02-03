# kbnw-express-app

This repository provides an hello world application based on express which will be automatically deployed to Kubernetes on Google Cloud Platform through a gitlab-ci configuration.

# Step by Step

## Setup Google Cloud Platform

1. Create your Google Cloud Platform Account at https://console.cloud.google.com
1. Start Cloud Shell
1. Clone git repository `git clone https://github.com/Pindar/gcloud-k8s-express-app.git && cd gcloud-k8s-express-app/`
1. Setup GCloud project `./k8s/setup_gcloud_project.sh [test-gitlabci-k8s-XXX]`, wait until project is ready
1. Setup GCloud resources `./k8s/setup_gcloud_resources.sh [test-gitlabci-k8s-XXX]`
1. Get gitlab-ci-token and prepare it for gitlab-ci `cat gitlab-ci-token.json | base64`, copy output to clipboard
1. Prepare variables at gitlab-ci

| Name                                 | Value                                                         |
|--------------------------------------|---------------------------------------------------------------|
| GCLOUD_GITLAB_CI_SERVICE_ACCOUNT_KEY | output of previous step                                       |
| CI_REGISTRY_IMAGE                    | eu.gcr.io/test-gitlabci-k8s-XXX/kbnw-express-app              | 
| CLUSTER_NAME                         | example-cluster                                               |
| GCLOUD_GITLAB_CI_SERVICE_ACCOUNT     | gitlab-ci-token@test-gitlabci-k8s-XXX.iam.gserviceaccount.com |
| GCLOUD_ZONE                          | europe-west1-b                                                |

1. adapt to your host names in k8s/ingress/ingress.yaml and .gitlab-ci.yml
1. let it run on gitlab-ci
1. update your DNS settings to the new ingress IP `kubectl --namespace=production get ing`
