#!/usr/bin/env bash

set -x

count=0

function message() {
  echo -e "\033[32m$(date '+%Y-%m-%d %H:%M:%S')  $1\033[0m"
}

function error_message() {
  echo -e "\033[31m$(date '+%Y-%m-%d %H:%M:%S')  $1\033[0m"
}

function check_go_command() {
  if ! command -v go &> /dev/null; then
    error_message "go is not executable"
    count=$((count+1))
  else
    message "go is executable"
  fi

  go_version=$(go version)
  MATRIX=$(echo "${SOFTWARE_MATRIX}" | sed 's/go-//')
  if [[ $go_version == *"${MATRIX}"* ]]; then
    message "go version is right"
  else
    error_message "go version is error"
    count=$((count+1))
  fi
}

function check_maven_command() {
  if ! command -v mvn &> /dev/null; then
    error_message "mvn is not executable"
    count=$((count+1))
  else
    message "mvn is executable"
  fi

  # validate mvn configuration
  if mvn -h 2>&1 | grep -q "JAVA_HOME"; then
    error_message "mvn configuration is error, JAVA_HOME is not set"
    count=$((count+1))
  fi
}

function check_nodejs_command() {
  if ! command -v node &> /dev/null; then
    error_message "node is not executable"
    count=$((count+1))
  else
    message "node is executable"
  fi

  node_version=$(node --version)
  MATRIX=$(echo "${SOFTWARE_MATRIX}" | sed 's/nodejs-//')
  if [[ "${node_version}" == *"${MATRIX}"* ]]; then
    message "node version is right"
  else
    error_message "node version is error"
    count=$((count+1))
  fi
}

function check_python_command() {
  if ! command -v python &> /dev/null; then
    error_message "python is not executable"
    count=$((count+1))
  else
    message "python is executable"
  fi

  if ! command -v pip &> /dev/null; then
    error_message "pip is not executable"
    count=$((count+1))
  else
    message "pip is executable"
  fi

  python_version=$(python --version 2>&1)
  MATRIX=$(echo "${SOFTWARE_MATRIX}" | sed 's/python-//')
  if [[ "${python_version}" == *"${MATRIX}"* ]]; then
    message "python version is right"
  else
    error_message "python version is error"
    count=$((count+1))
  fi
}

main() {
  if [[ "${SOFTWARE_MATRIX}" == *"go"* ]]; then
    check_go_command
  elif [[ "${SOFTWARE_MATRIX}" == *"java"* ]]; then
    check_maven_command
  elif [[ "${SOFTWARE_MATRIX}" == *"python"* ]]; then
    check_python_command
  elif [[ "${SOFTWARE_MATRIX}" == *"nodejs"* ]]; then
    check_nodejs_command
  fi

  if [ ${count} -ne 0 ]; then
    exit 1
  fi
}

main "$@"