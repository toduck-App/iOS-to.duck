#!/bin/sh
echo "installing Tuist.."

brew tap tuist/tuist
brew install tuist@4.18.0

echo "installed Tuist"
cd ..
tuist clean
tuist install
tuist generate --no-binary-cache
