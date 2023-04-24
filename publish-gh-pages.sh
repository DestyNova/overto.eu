#!/bin/bash

set -euo pipefail

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
hugo --minify

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish-gh-pages.sh)" && cd .. && git push --force origin gh-pages
