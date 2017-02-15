#!/usr/bin/env bash

# Bail on errors
set -e

REPOS=/var/www/repos
# Generate a new directory to clone to
NEW_CLONE=$REPOS/markdown-journal-`date +%s`
NEW_BUILD=$NEW_CLONE/build
TARGET=/var/www/markdown-journal/build
PREVIOUS_LINK=$REPOS/markdown-journal-previous

# Do the clone
echo "Cloning Markdown Journal"
git clone git@github.com:captbaritone/markdown-journal.git $NEW_CLONE > /dev/null

echo "Installing Node requirements"
( cd $NEW_CLONE && npm install)

#echo "Run tests"
#( cd $NEW_CLONE && npm run test )

echo "Build the webpack bundle"
( cd $NEW_CLONE && npm run build)

echo "Cleaning up node_modules/ to save space"
( cd $NEW_CLONE && rm -r node_modules)

PREVIOUS=$(readlink -f $TARGET)

echo "The previous buid was: $PREVIOUS"

echo "Creating 'previous' link $PREVIOUS_LINK to enable reverts"
ln -snf $PREVIOUS $PREVIOUS_LINK

echo "Linking new Markdown Journal into place"
ln -snf $NEW_BUILD/ $TARGET

echo "Done!"