#!/usr/bin/env bash

set -e

executable_tools=(make gcc wget git curl autoconf zip unzip jq vim gettext tree yq argocd kubectl-argo-rollouts kustomize sonar-scanner helm docker kubectl)
rpm_packages=(gcc-c++ openssl-devel glibc-common)
dep_packages=(g++ libcurl4-openssl-dev libssl-dev locales)
count=0

function message() {
  echo -e "\033[32m$(date '+%Y-%m-%d %H:%M:%S')  $1\033[0m"
}

function error_message() {
  echo -e "\033[31m$(date '+%Y-%m-%d %H:%M:%S')  $1\033[0m"
}

# check the command is executable
function check_command() {
  if ! command -v "${1}" &> /dev/null; then
    error_message "${1} is not executable"
    count=$((count+1))
  else
    message "${1} is executable"
  fi
}

# centos: check the package is installed in rpm
function check_rpm() {
  if ! rpm -q "${1}" &> /dev/null; then
    error_message "${1} is not installed in rpm"
    count=$((count+1))
  else
    message "${1} is installed in rpm"
  fi
}

# ubuntu: check the package is installed in dep
function check_dep() {
  if ! dpkg -l | grep "$1" &> /dev/null; then
    error_message "$1 package is not installed in dep"
    count=$((count+1))
  else
    message "${1} is installed in dep"
  fi
}

main() {
  for tool in ${executable_tools[*]}; do
    check_command "${tool}"
  done

  if [[ "${AGENT_IMAGE}" == *"ubuntu"* ]]; then
    for package in ${dep_packages[*]}; do
      check_dep "${package}"
    done
  else
    for package in ${rpm_packages[*]}; do
      check_rpm "${package}"
    done
  fi

  if [ ${count} -ne 0 ]; then
    exit 1
  fi
}

main "$@"