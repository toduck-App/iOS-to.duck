echo "=================================================================="
echo "Toduck Script"
echo "=================================================================="
# mise 설치
if ! command -v mise &> /dev/null; then
  echo "\n[7] > Installing mise ...\n"
  curl https://mise.run | sh
else
  echo "mise is already installed."
fi

# mise 활성화
echo "\n[8] > Activating mise ...\n"
if ! grep -q 'eval "$(~/.local/bin/mise activate zsh)"' ~/.zshrc; then
  echo 'eval "$(~/.local/bin/mise activate zsh)"' >> ~/.zshrc
else
  echo "mise is already activated in ~/.zshrc"
fi

echo "=================================================================="
echo "Generate Script"
echo "=================================================================="

EXECUTION_DIR=${PWD}
echo "- Executed From: ${EXECUTION_DIR}"

SCRIPT_PATH=$(readlink -f "$0")
echo "- Script Path: ${SCRIPT_PATH}"

SCRIPT_DIR=$(dirname "$SCRIPT_PATH")
echo "- Script Directory: ${SCRIPT_DIR}"

WORKSPACE_DIR="$(dirname "$(dirname "${SCRIPT_DIR}")")"
echo "- Workspace Directory: ${WORKSPACE_DIR}"

PROJECT_DIR_NAME="Projects"
PROJECT_NAME="App"
PROJECT_DIR="${WORKSPACE_DIR}/${PROJECT_DIR_NAME}/${PROJECT_NAME}"
echo "- Project Directory: ${PROJECT_DIR}"
echo "------------------------------------------------------------------"

echo "global 설정"
mise use --global node@20
echo "\n[1] > mise install and use tuist ...\n"
mise install tuist
mise use tuist@4.18.0

echo "global tuist setting"
mise use -g tuist

# Tuist install 실행
echo "\n[2] > Installing Tuist ...\n"
tuist install --path "${WORKSPACE_DIR}"

# Tuist generate 실행 및 프로젝트 open
echo "\n[3] > Generating Tuist ...\n"
if [ "$1" = "--no-open" ]; then
    TUIST_ROOT_DIR=$PWD tuist generate --no-open
else
    TUIST_ROOT_DIR=$PWD tuist generate
fi

echo "\n—————————————————"
echo "::: Generate Script Finished :::"
echo "—————————————————\n"
