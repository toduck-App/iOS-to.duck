#!/bin/sh
# Tuist 설치 확인 및 설치
if ! command -v tuist &> /dev/null
then
    echo "Tuist가 설치되어 있지 않습니다. 설치를 시작합니다."
    curl -Ls https://install.tuist.io | bash
    export PATH="$HOME/.tuist/bin:$PATH"
else
    echo "Tuist가 이미 설치되어 있습니다."
fi

# Tuist 업데이트 (선택 사항)
tuist install

# Tuist generate 실행
echo "Tuist generate를 실행합니다."
tuist generate

echo "모든 작업이 완료되었습니다."