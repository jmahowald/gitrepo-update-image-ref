#!/bin/bash -ex

export GITHUB_TOKEN=${GITHUB_TOKEN:-$INPUT_GITHUB_TOKEN}
export GITHUB_USER=${GITHUB_USER:-$INPUT_GITHUB_USER}
export INPUT_REMOTE_REPO_BRANCH=${INPUT_REMOTE_REPO_BRANCH:-develop}
repo_dir=$(echo $INPUT_REMOTE_REPO_NAME  | cut -d "/" -f 2)

env
if [ ! -d $repo_dir ]; then
    git clone --depth 1 \
    https://$GITHUB_USER:$GITHUB_TOKEN@github.com/$INPUT_REMOTE_REPO_NAME.git \
    -b $INPUT_REMOTE_REPO_BRANCH
    pushd $repo_dir
else
    echo "already updated repo"
    pushd $repo_dir
    git pull
fi

git config --local user.email $INPUT_GIT_COMMITTER_EMAIL
git config --local user.name $INPUT_GIT_COMMMITTER_NAME


yq write -i $INPUT_REMOTE_REPO_PATH $INPUT_VARIABLE_NAME $GITHUB_SHA
git add $INPUT_REMOTE_REPO_PATH
git commit -m "Updating $INPUT_VARIABLE_NAME sha reference"


git push 

