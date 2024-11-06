package main
agents := {
  "base": {"container": "base", "image": "docker.io/amambadev/jenkins-agent-base:latest-ubuntu-podman"},
  "go": {"container": "go", "image": "docker.io/amambadev/jenkins-agent-go:latest-1.22.6-ubuntu-podman"},
  "python": {"container": "python", "image": "docker.io/amambadev/jenkins-agent-python:latest-3.8.19-ubuntu-podman"},
  "maven": {"container": "maven", "image": "docker.io/amambadev/jenkins-agent-maven:latest-jdk8-ubuntu-podman"},
  "nodejs": {"container": "nodejs", "image": "docker.io/amambadev/jenkins-agent-nodejs:latest-16.20.2-ubuntu-podman"},
}
