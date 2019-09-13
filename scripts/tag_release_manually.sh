#!/bin/bash

TAG_ID=$2
GITHUB_API_TOKEN=$1

OWNER="snowdrop"
REPO="generator"
AUTH="Authorization: token $GITHUB_API_TOKEN"
GH_API="https://api.github.com"
GH_REPO="$GH_API/repos/$OWNER/$REPO"

require_clean_work_tree () {
    # Update the index
    git update-index -q --ignore-submodules --refresh
    err=0

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --
    then
        echo >&2 "cannot $1: you have unstaged changes."
        git diff-files --name-status -r --ignore-submodules -- >&2
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --
    then
        echo >&2 "cannot $1: your index contains uncommitted changes."
        git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
        err=1
    fi

    if [ $err = 1 ]
    then
        echo >&2 "Please commit or stash them."
        exit 1
    fi
}

require_clean_work_tree

#echo "Tagging ..."
#git tag -a $TAG_ID -m "$TAG_ID"
#
#echo "Releasing $TAG_ID ..."
#JSON='{"tag_name": "'"$TAG_ID"'","target_commitish": "master","name": "'"$TAG_ID"'","body": "'"$TAG_ID"'","draft": false,"prerelease": false}'
#curl -H "$AUTH" \
#    -H "Content-Type: application/json" \
#    -d "$JSON" \
#    $GH_REPO/releases
