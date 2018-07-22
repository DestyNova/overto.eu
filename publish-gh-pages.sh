#!/bin/bash

set -euo pipefail

DIR=$(dirname "$0")

cd $DIR/..

echo "Now in: $(pwd)"

wat

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Pruning old version..."
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public..."
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files (again?)"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cp CNAME public
cd public && git add --all && git commit -m "Publishing to gh-pages (publish-gh-pages.sh)" && cd .. && git push origin gh-pages
