#! /bin/bash

#docker build -t andreassolberg/smedstua -t gcr.io/solberg-cluster/ .
docker build -t gcr.io/solberg-cluster/smedstua:latest .
gcloud docker push gcr.io/solberg-cluster/smedstua:latest
kubectl rolling-update smedstuarc-v7 --image=gcr.io/solberg-cluster/smedstua:latest
