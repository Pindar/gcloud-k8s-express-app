# How to install

1. Prepare config-map: change token according to your runners page at gitlab https://gitlab.com/[USER]/[PROJECT-NAME]/runners, `sed -i.bak 's#"...."#"YOUR_TOKEN"#' ./k8s/gitlab-ci-runner/config-map.yaml`
1. Setup Gitlab CI runner
```
kubectl get ns gitlab || kubectl create ns gitlab \
&& kubectl create -f ./k8s/gitlab-ci-runner/config-map.yaml \
&& kubectl create -f ./k8s/gitlab-ci-runner/deployment.yaml
```
