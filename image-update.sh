#!/bin/bash
#
# use this script to update, version, & push the container
#
# be sure the following vars are defined in the run environment:
#
# GIT_USER=
# GIT_REPO_API_KEY=
# GIT_REPO_NAME=
# DOCKER_REPO_NAME=

GITHUB_REPO_PREFIX=https://api.github.com/repos
GITHUB_REPO_SUFFIX=tags
BITBUCKET_REPO_PREFIX=https://api.bitbucket.org/2.0/repositories
BITBUCKET_REPO_SUFFIX=refs/tags
GIT_REPO_API_PREFIX=$GITHUB_REPO_PREFIX
GIT_REPO_API_SUFFIX=$GITHUB_REPO_SUFFIX

set -e
set -x

GIT_REPO_VER=`curl -u $GIT_USER:$GIT_REPO_API_KEY} ${GIT_REPO_API_PREFIX}/${GIT_USER}/${GIT_REPO_NAME}/${GIT_REPO_SUFFIX} \
                  | json | grep '"name":' | grep -o '[0-9]*\.[0-9]*\.[0-9]*' \
                  | uniq | sort | tail -1`
                  # not on mac: --version-sort` #
# get checksum from CI server when possible
echo "Building container for $GIT_REPO_NAME version $GIT_REPO_VER"

docker build --build-arg DOCKER_REPO_VER=$GIT_REPO_VER \
             --no-cache --pull \
             --tag ${DOCKER_REPO_NAME}:$DOCKER_REPO_VER .

docker tag -f ${DOCKER_REPO_NAME}:$DOCKER_REPO_VER ${DOCKER_REPO_NAME}:latest

docker push ${DOCKER_REPO_NAME}:$DOCKER_REPO_VER
docker push ${DOCKER_REPO_NAME}:latest
