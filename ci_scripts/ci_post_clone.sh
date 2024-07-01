#!/bin/sh
curl https://mise.jdx.dev/install.sh | sh
mise install # Installs the version from .mise.toml

# Runs the version of Tuist indicated in the .mise.toml file
mise x tuist generate