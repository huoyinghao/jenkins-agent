#!/bin/bash
set -o errexit
set -o nounset
set -o pipefail

# this script used for updating the .relok8s-images.yaml file with the images from the values.yaml file

wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64.tar.gz -O - | tar xz &&  yq --version

values_file=${values_file:-"charts/values.yaml"}
relok8s_file=${relok8s_file:-"charts/.relok8s-images.yaml"}

function process_builder() {
    local builder_name=$1
    local image="{{ .Agent.Builder.$builder_name.Image }}"
    local versions=($(yq eval ".Agent.Builder.$builder_name.Versions[]" "$values_file"))
    for version in "${versions[@]}"; do
        entry="- \"{{ .image.registry }}/$image:$version\""
        entryPodman="- \"{{ .image.registry }}/$image:$version-podman\""

        if ! grep -q "$image:$version" "$relok8s_file"; then
            echo "adding image: $entry"
            echo "$entry" >> "$relok8s_file"
        fi

        if ! grep -q "$image:$version-podman" "$relok8s_file"; then
            echo "adding image: $entryPodman"
            echo "$entryPodman" >> "$relok8s_file"
        fi
    done
}

yq --version

process_builder "NodeJs"
process_builder "Maven"
process_builder "Golang"
process_builder "Python"