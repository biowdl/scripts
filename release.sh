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
VERSION_FILE="VERSION"

function check_tagged_submodules {
    echo "Check if all submodules are tagged"
    git submodule update --init --recursive
    git submodule foreach --recursive \
    bash -c 'if [ "$(git tag -l --points-at HEAD)" == "" ] ; \
    then echo "Untagged submodule found. Please make sure all submodules are released. Aborting release procedure." && exit 1 ;\
    else echo "contains tag: $(git tag -l --points-at HEAD)" ;\
    fi'
}

# Checking out latest version of develop.
cd $GIT_ROOT
echo "Checking out develop"
git checkout develop
echo "Get latest develop branch"
git pull origin develop

# Checking if pipeline is ready for release.
check_tagged_submodules

# Merging into master.
echo "Merge develop into master"

# We need to force checking out master.
# Otherwise the script will sometimes randomly fail.
git checkout -f  master
git pull origin master
git merge origin/develop

# Another check to see if after merging everything still is okay.
check_tagged_submodules

# TODO: Add command that does a quick test of the pipeline.
# Womtool validate maybe?

# Set release version.
if [ -f $VERSION_FILE ]
then
    CURRENT_VERSION="$(cat $VERSION_FILE)"
    read -p $"To be released version is $CURRENT_VERSION. Type a different version if required (Leave empty for $CURRENT_VERSION)"$'\n' \
    CURRENT_VERSION_OVERRIDE
    if [ "$CURRENT_VERSION_OVERRIDE" != "" ]
    then
        CURRENT_VERSION="$CURRENT_VERSION_OVERRIDE"
    fi
else
    read -p $"No version file at location '$VERSION_FILE' was found. What version do you want to release?"$'\n' \
    CURRENT_VERSION
fi

echo "Version to be released = $CURRENT_VERSION"
RELEASE_TAG="v$CURRENT_VERSION"
echo "Tagging release: $RELEASE_TAG"
git tag -a $RELEASE_TAG

echo "Tagging successfull"
echo "push release to remote repository?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) git push origin master && git push origin $RELEASE_TAG; break;;
        No ) echo "release aborted" && exit 1;;
    esac
done

git checkout develop
git merge master
echo "Released version was: $CURRENT_VERSION"
read -p $"What should be the next version?"$'\n' NEXT_VERSION
echo "Setting next version to be: $NEXT_VERSION"
echo "$NEXT_VERSION" > $VERSION_FILE
git add $VERSION_FILE
git commit -m "setting next version"

echo "push develop with new version '$NEXT_VERSION' to remote repository?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) git push origin develop; break;;
        No ) echo "remote push aborted" && exit 1;;
    esac
done
echo "release procedure successful"
