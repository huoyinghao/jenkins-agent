#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
set -x

echo "Installing qemu"
version="v7.2.0-1"
archs=("aarch64" "arm" "x86_64" "alpha" "armeb" "i386" "loongarch64" "riscv64")
qemu_bin_dir="/usr/bin"
for arch in ${archs[@]}; do
  echo "Downloading qemu-${arch}-static"
  wget -q -t 3 https://github.com/multiarch/qemu-user-static/releases/download/${version}/qemu-"${arch}"-static
  chmod +x qemu-"${arch}"-static
  mv qemu-"${arch}"-static /usr/bin
done

ls -al /usr/bin/qemu-*
