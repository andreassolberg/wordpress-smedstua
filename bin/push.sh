#!/bin/bash
#
echo "Working on branch ${TRAVIS_BRANCH}"

if [ "$TRAVIS_BRANCH" = "master" ]; then
    echo "Tagging MASTER ${PACKAGE}:${TRAVIS_COMMIT} as ${PACKAGE}:unstable"
    docker tag ${PACKAGE}:${TRAVIS_COMMIT} ${PACKAGE}:unstable
fi

if [ "$TRAVIS_BRANCH" = "stable" ]; then
    echo "Tagging MASTER ${PACKAGE}:${TRAVIS_COMMIT} as ${PACKAGE}:stable"
    docker tag ${PACKAGE}:${TRAVIS_COMMIT} ${PACKAGE}:stable
fi