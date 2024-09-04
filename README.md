# jenkins-agent

including mirrors of various languages

while we update jenkins version，we should change github workflows first

## update agent version

when you want update jenkins agent versions, just do the following steps:
1. vim version.yaml, add some new version for some language
2. run `make update-agents-version` to auto update the following files:
   - helm chart values.yaml
   - github action yaml
   - .relok8s-images.yaml
   - some .rego files to verify images