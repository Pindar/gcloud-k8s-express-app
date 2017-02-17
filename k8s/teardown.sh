#!/bin/bash

# delete ingress explicitly because otherwise you will have left over resources in your google cloud platform
# e.g., load balancer, health check etc. won't be removed
kubectl delete ing k8s/ingress/ingress.yaml --namespace production
kubectl delete ns production
