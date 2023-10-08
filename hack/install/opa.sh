#!/bin/bash

which opa > /dev/null 2>&1 && exit 0

curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
chmod 755 opa
sudo mv opa /usr/local/bin