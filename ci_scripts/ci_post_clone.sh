#!/bin/sh
echo "install"
curl https://mise.jdx.dev/install.sh | sh
mise install # Installs the version from .mise.toml

mise x tuist generate