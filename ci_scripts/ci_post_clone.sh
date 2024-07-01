#!/bin/sh
echo "installing Tuist.."

brew tap tuist/tuist
brew install tuist
brew install tuist@x.y.z

echo "installed Tuist"

tuist clean
tuist install
tuist generate