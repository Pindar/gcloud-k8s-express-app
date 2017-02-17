# How to install

1. Get Gitlab-CI Token by running `gitlab-ci-multi-runner register` somewhere and use the [register token](https://gitlab.com/[USER]/[PROJECT-NAME]/runners)
1. Prepare config-map: change access token according to what you now find in `cat /etc/gitlab-runner/config.toml` , `sed -i.bak 's#"...."#"YOUR_TOKEN"#' ./k8s/gitlab-ci-runner/config-map.yaml`
1. Setup Gitlab CI runner
```
kubectl get ns gitlab || kubectl create ns gitlab \
&& kubectl create -f ./k8s/gitlab-ci-runner/config-map.yaml \
&& kubectl create -f ./k8s/gitlab-ci-runner/deployment.yaml
```
1. Set environment variable `DOCKER_HOST=tcp://localhost:2375` as secret variable in gitlab. For more information check out https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/blob/master/docs/executors/kubernetes.md

Remark:

- If you wonder why your token doesn't work you probably use the wrong one. For more information please read through https://gitlab.com/gitlab-org/gitlab-ci-multi-runner/issues/9
- And if you get an error like "Too Many Requests" check this out https://gitlab.com/gitlab-com/infrastructure/issues/348
- The instructions you will find at https://docs.gitlab.com/runner/install/kubernetes.html doesn't work on GKE because
  the mozilla certificates folder doesn't exist. That's the reason for the adapted ones in this example.

# Clean up

```
kubectl delete -f ./k8s/gitlab-ci-runner/config-map.yaml \
  && kubectl delete -f ./k8s/gitlab-ci-runner/deployment.yaml \
  && kubectl ns gitlab
```
