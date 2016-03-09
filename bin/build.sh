#!/bin/bash


PACKAGE=gcr.io/solberg-cluster/smedstua

echo "Building image ${PACKAGE}:${TRAVIS_COMMIT}"

docker build -t ${PACKAGE}:${TRAVIS_COMMIT}


if [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Tagging MASTER ${PACKAGE}:${TRAVIS_COMMIT} as ${PACKAGE}:unstable"
    docker tag ${PACKAGE}:${BUILD_TAG} ${PACKAGE}:unstable
fi

if [ "$TRAVIS_BRANCH" = "stable" ]; then
    echo "Tagging MASTER ${PACKAGE}:${TRAVIS_COMMIT} as ${PACKAGE}:stable"
    docker tag ${PACKAGE}:${BUILD_TAG} ${PACKAGE}:stable
fi


# docker tag ${PACKAGE}:${BUILD_TAG} ${PACKAGE}:unstable
# echo $TRAVIS_BRANCH
# echo ${TRAVIS_COMMIT}