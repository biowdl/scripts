#!/usr/bin/env bash

# Copyright (c) 2019 Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -eu

GIT_ROOT="$(git rev-parse --show-toplevel)"
cd $GIT_ROOT

# Determine the version.
TAG=`git tag -l --points-at HEAD`
if [ "${TAG}" == '' ]
  then
    BRANCH=`git rev-parse --abbrev-ref HEAD`
    if [ "${BRANCH}" == 'develop' ]
      then
        VERSION='develop'
      else
        echo 'You are currently not on a tagged commit or develop!'
        exit 1
    fi
  else
    VERSION="${TAG}"
fi
echo "Updating documention for version ${VERSION}"

# Checkout gh-pages and pull the docs over from the original branch.
git checkout gh-pages
git pull
git checkout $VERSION -- docs

# Rename the docs to the version.
if [ -d "${VERSION}" ]
  then
    git rm -r $VERSION
fi
mv docs $VERSION

# Adjust the config if necessary.
echo "set version '${VERSION}' to latest?"
select yn in "Yes" "No"
  do
    case $yn in
        Yes ) sed -i "s/latest: .*/latest: ${VERSION}/" _config.yml; break;;
        No ) break;;
    esac
done
grep 'latest:' < _config.yml

# Commit and push.
echo "committing and pushing"
git add ${VERSION}/* _config.yml docs/*
git commit -m "update documention for version ${VERSION}"
git push origin gh-pages

# Switch back to version.
git checkout $VERSION

echo "DONE"
