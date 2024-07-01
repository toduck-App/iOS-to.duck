#!/bin/sh
echo "install"
curl https://mise.jdx.dev/install.sh | sh
mise install 
mise x tuist generate