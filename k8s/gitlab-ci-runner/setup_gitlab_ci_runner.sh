#!/bin/bash

if [[ "$1" = "" ]]; then
  echo "usage specify gitlab runner token";
  exit 1;
fi

cd "$( dirname "${BASH_SOURCE[0]}" )"

TOKEN=$1

sed -i.bak "s#\"....\"#\"$TOKEN\"#" config-map.yaml

kubectl get ns gitlab || kubectl create ns gitlab \
  && kubectl create -f config-map.yaml \
  && kubectl create -f deployment.yaml
