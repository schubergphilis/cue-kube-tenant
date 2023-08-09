# Setting SHELL to bash allows bash commands to be executed by recipes.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec
DEFAULT=help

MODULE=tenant

.PHONY: help test build push tools

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

tools: ## Install cue, kind, Timoni
	brew bundle

get: ## Update Kubernetes API CUE definitions
	@go mod init
	@go get -u k8s.io/api/...
	@go get -u k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1
	@cue get go k8s.io/api/core/v1
	@cue get go k8s.io/api/apps/v1
	@cue get go  k8s.io/api/rbac/v1
	@cue get go k8s.io/apimachinery/pkg/apis/meta/v1
	@cue get go k8s.io/apimachinery/pkg/runtime
	@cue get go k8s.io/apiextensions-apiserver/pkg/apis/apiextensions/v1
	@rm go.mod go.sum

vet: ## Format and vet all CUE definitions
	@cue fmt ./... && cue vet --all-errors --concrete ./...

test: ## Build with test_tool.cue + test_values.cue
	@cue -t test build .

gen: vet ## Print the CUE generated objects
	@cd modules/flux-aio
	@cue gen

kind: ## Create kind cluster
	@kind create cluster --config ./test/kind.yaml

build: ## Build with timoni with ns+name provided as arg/flag
	@timoni build -n testing test . 

apply: ## Apply the module with default values
	@kubectl create ns test
	@timoni apply -n test test-tenant ./ --timeout=1m

push: ## Push the module with timoni
	@timoni mod push . \
        oci://ghcr.io/${OWNER}/cue-modules/$(MODULE) \
        --version ${TAG} \
        --creds ${USER}:${PASS}
