#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -x

ARCH=$(uname -m)
echo "install golang with version: $GO_VERSION"

if [[ ${ARCH} == 'x86_64' ]]; then
  ARCH_PATH="amd64"
elif [[ ${ARCH} == 'aarch64' ]]; then
  ARCH_PATH="arm64"
else
  echo "golang do not support this arch"
  exit 1
fi

wget https://golang.google.cn/dl/go$GO_VERSION.linux-${ARCH_PATH}.tar.gz
tar -xvf go$GO_VERSION.linux-${ARCH_PATH}.tar.gz
rm -rf go$GO_VERSION.linux-${ARCH_PATH}.tar.gz
mv go /usr/local/go
go version