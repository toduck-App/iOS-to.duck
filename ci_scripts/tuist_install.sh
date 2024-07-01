// tuist_install.sh파일
#!/bin/sh

curl -Ls https://install.tuist.io | bash

echo "tuist install..."

brew install tuist@4.18.0

tuist clean --path ..
tuist install --path ..
tuist generate --path ..
