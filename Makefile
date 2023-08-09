# Setting SHELL to bash allows bash commands to be executed by recipes.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec
DEFAULT=help

MODULE=tenant

.PHONY: help test build push

help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

test: ## Build with test_tool.cue + test_values.cue
	@cue -t test build .


build: ## Build with timoni with ns+name provided as arg/flag
	@timoni build -n testing test . 

push: ## Push the module with timoni
	@timoni mod push . \
        oci://ghcr.io/${OWNER}/cue-modules/$(MODULE) \
        --version ${TAG} \
        --creds ${USER}:${PASS}
