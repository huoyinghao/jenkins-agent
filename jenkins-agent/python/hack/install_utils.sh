#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -x

echo "install python with version: $VERSION"

apt-get update && apt-get install -y zlib1g-dev

wget https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tgz
tar xvf Python-${VERSION}.tgz
cd Python-${VERSION}
./configure --enable-optimizations
make -j 8
make install
rm -rf /usr/local/bin/python
mv /usr/local/bin/${PYTHON_VERSION} /usr/local/bin/python
cd ..
rm -rf Python-${VERSION}
rm Python-${VERSION}.tgz

apt-get update && apt-get install -y python3-pip
mv /usr/bin/pip3 /usr/bin/pip

pip --version
python --version
