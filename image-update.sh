#!/bin/bash
#
# use this script to update, version, & push the container
#
# mac: ln -s /usr/local/bin/gsort /usr/local/bin/sort
#   assuming path prefers usr
# be sure the following vars are defined in the run environment:
#
# GIT_USER=
# GIT_REPO_API_KEY=
# GIT_REPO_NAME=
# DOCKER_REPO_NAME=

set -e
set -x

GITHUB_REPO_PREFIX=https://api.github.com/repos
GITHUB_REPO_SUFFIX=tags
BITBUCKET_REPO_PREFIX=https://api.bitbucket.org/2.0/repositories
BITBUCKET_REPO_SUFFIX=refs/tags
GIT_REPO_URL_PREFIX=$GITHUB_REPO_PREFIX
GIT_REPO_URL_SUFFIX=$GITHUB_REPO_SUFFIX
# GIT_REPO_API_PREFIX=$BITBUCKET_REPO_PREFIX
# GIT_REPO_API_SUFFIX=$BITBUCKET_REPO_SUFFIX

# curl -H "Authorization: token OAUTH-TOKEN" https://api.github.com
# -u $GIT_USER:$GIT_REPO_API_KEY}

GIT_REPO_VER=`curl ${GIT_REPO_URL_PREFIX}/${GIT_USER}/${GIT_REPO_NAME}/${GIT_REPO_URL_SUFFIX} \
                  | json -a name | grep -o '\d\+.\d\+.\d\+' | uniq | sort | tail -1`
# get checksum from CI server when possible
echo "Building container for $GIT_REPO_NAME version $GIT_REPO_VER"

docker build --build-arg DOCKER_REPO_VER=$GIT_REPO_VER \
             --no-cache --pull \
             --tag ${DOCKER_REPO_NAME}:$GIT_REPO_VER .

docker tag -f ${DOCKER_REPO_NAME}:$GIT_REPO_VER ${DOCKER_REPO_NAME}:latest

docker push ${DOCKER_REPO_NAME}:$GIT_REPO_VER
docker push ${DOCKER_REPO_NAME}:latest
