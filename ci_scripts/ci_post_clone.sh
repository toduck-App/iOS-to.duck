#!/bin/sh
echo "install"
curl https://mise.jdx.dev/install.sh | sh
echo "moving"
mise install 
mise x tuist generate