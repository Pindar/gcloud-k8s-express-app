#!/bin/bash -e

cd "$( dirname "${BASH_SOURCE[0]}" )"

kubectl delete -f config-map.yaml \
  && kubectl delete -f deployment.yaml \
  && kubectl delete ns gitlab
