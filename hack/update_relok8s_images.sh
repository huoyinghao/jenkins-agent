#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail
#set -x

# this script used for updating the .relok8s-images.yaml file with the images from the values.yaml file

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64.tar.gz -O - | tar xz &&  yq --version
yq --version

values_file=${values_file:-"charts/values.yaml"}
relok8s_file=${relok8s_file:-"charts/.relok8s-images.yaml"}

function process_builder() {
    local builder_name=$1
    local image="{{ .Agent.Builder.$builder_name.Image }}"
    local versions=($(yq eval ".Agent.Builder.$builder_name.Versions[]" "$values_file"))
    local runtime=("docker" "podman")
    local os=("centos" "ubuntu")
    for os_type in "${os[@]}"; do
        for rt in "${runtime[@]}"; do
            for version in "${versions[@]}"; do
                suffix=""
                if [ "$os_type" == "ubuntu" ]; then
                    suffix=$suffix"-ubuntu"
                fi
                if [ "$rt" == "podman" ]; then
                    suffix=$suffix"-podman"
                fi
                entry="- \"{{ .image.registry }}/$image:$version$suffix\""


                echo "Checking image: $entry"

                if [ "$os_type" == "centos" ]; then
                  if [ "$builder_name" == "Golang" ] && [[ "$version" =~ "1.17.13" ]]; then
                      echo "$image:$version$suffix"
                     if ! grep -F "$image:$version$suffix" "$relok8s_file"; then
                        echo "Adding image: $entry"
                        echo "$entry" >> "$relok8s_file"
                     fi
                  fi
                else
                    if ! grep -F "$image:$version$suffix" "$relok8s_file"; then
                        echo "Adding image: $entry"
                        echo "$entry" >> "$relok8s_file"
                    fi
                fi
            done
        done
    done
}

process_builder "NodeJs"
process_builder "Maven"
process_builder "Golang"
process_builder "Python"