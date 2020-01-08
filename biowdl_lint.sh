#!/usr/bin/env bash

# Validate every WDL file in the repository with womtool validate and miniwdl check.
# Also check parameter_meta presence unless the argument "skip-wdl-aid" is given.
set -e
for WDL_FILE in $(git ls-files *.wdl)
  do
    echo $WDL_FILE
    womtool validate $WDL_FILE
    miniwdl check $WDL_FILE
    if [[ "$1" != "skip-wdl-aid" ]]
      then
        wdl-aid --strict $WDL_FILE > /dev/null
      fi
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
