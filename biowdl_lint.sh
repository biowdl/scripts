#!/usr/bin/env bash

set -e
for WDL_FILE in $(git ls-files *.wdl)
  do
    echo $WDL_FILE
    womtool validate $WDL_FILE
  done

# For each submodule
# 1. Check if there is a tag. If so, we are using a stable version.
# 2. If not, we must be on the main develop branch. Make sure it is the
#    latest version of this branch.
# Afterwards check if there are changes. If so, some submodules have been
# updated to a newer commit, so that means they were not on develop. In that
# case exit 1.

git submodule foreach \
bash -c '\
if [ "$(git tag --contains)" == "" ]; \
  then git checkout develop && git pull && \
  git submodule update --init --recursive ; \
  else echo "on tag: $(git tag --contains)" ; \
fi
'
git diff --exit-code || \
(echo ERROR: Git changes detected. Submodules should either be tagged or on the latest version of develop. && exit 1)
