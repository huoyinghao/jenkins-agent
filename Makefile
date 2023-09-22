include Makefile.defs

NAMESPACE ?= "jenkins"
INSTALLATION_NAME ?= "jenkins"
DEPLOY_ENV ?= ""
VERSION ?= ""
FILENAME := ""
ifeq ($(VERSION), "")
    LATEST_TAG=$(shell  git describe --tags --abbrev=8)
    ifeq ($(LATEST_TAG),)
        # Forked repo may not sync tags from upstream, so give it a default tag to make CI happy.
        VERSION="unknown"
    else
        VERSION=$(LATEST_TAG)
    endif
endif


CHART_VERSION ?= $(shell echo ${VERSION} | sed 's/-/+/1' | sed  's/^v//g' )


.PHONY: lint
lint:
	helm lint charts

.PHONY: render
render:
	helm template jenkins charts -n $(NAMESPACE) --create-namespace \
		 --set image.pullPolicy=Always --debug --dry-run

.PHONY: build
build:
	./hack/build.sh

.PHONY: deploy
deploy:
	./hack/deploy.sh


.PHONY: e2e-test
e2e-test:
	./hack/e2e-test.sh $(VERSION)


.PHONY: local-e2e-test
local-e2e-test:
	KIND_IMAGE="release-ci.daocloud.io/kpanda/kindest-node:v1.26.0" ./hack/e2e-test.sh $(VERSION)