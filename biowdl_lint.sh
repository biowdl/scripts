#!/usr/bin/env bash

set -e
for WDL_FILE in $(git ls-files *.wdl)
  do
    echo $WDL_FILE
    womtool validate $WDL_FILE
  done
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
