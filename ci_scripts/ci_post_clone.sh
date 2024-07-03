#!/bin/sh

echo "=================================================================="
echo "ci_post_clone Script"
echo "=================================================================="
brew tap tuist/tuist
echo "installing Tuist.."
brew install tuist@4.18.0
echo "installed Tuist"
echo "------------------------------------------------------------------"

cd ..
echo "tuist cleaning"
tuist clean
echo "tuist installing"
tuist install
echo "tuist generating"
tuist generate --no-binary-cache
echo "=================================================================="
echo "tuist setting finish"
echo "=================================================================="
