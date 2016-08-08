#!/bin/env bash
# set -e

# something like:
# version {
      # echo "update.sh version called. "

#     local new_ver = shift
#     sed -i -e 's/^Version.*$/Version ${NEW_VER}/' README.md
#     sed -i -e 's|^\s+image: .*|${REPO_NAME}:${NEW_VER}|o' docker-compose.yml
#     git tag $NEW_VER
#     git push; git push --tags
# }
# except auto-gen the ver tag in here.

# or just use make
# cmd=$1
# if [ ! -z "$cmd" ]; then
#     shift 1
#     $cmd "$@"
#     exit
# fi
#
# help
