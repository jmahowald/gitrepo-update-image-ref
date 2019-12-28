#!/bin/bash -ex




export BRANCH_NAME=${GITHUB_REF##*/}

if [ "$BRANCH_NAME" != "$INPUT_ONLY_IF_BRANCH" ]; then
    echo "current branch is not $INPUT_ONLY_IF_BRANCH.  Ignoring "
    exit 0
fi


export GITHUB_TOKEN=$INPUT_GITHUB_TOKEN
export GITHUB_USER=${GITHUB_USER:-$INPUT_GITHUB_USER}
export INPUT_REMOTE_REPO_BRANCH=${INPUT_REMOTE_REPO_BRANCH:-develop}
repo_dir=$(echo $INPUT_REMOTE_REPO_NAME  | cut -d "/" -f 2)




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

git config --local user.email $INPUT_GIT_COMMITER_EMAIL
git config --local user.name $INPUT_GIT_COMMITER_NAME


yq write -i $INPUT_REMOTE_REPO_PATH $INPUT_VARIABLE_NAME $GITHUB_SHA
git add $INPUT_REMOTE_REPO_PATH
git commit -m "Updating $INPUT_VARIABLE_NAME sha reference"


git push 

