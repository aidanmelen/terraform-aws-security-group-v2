NAME = terraform-kubernetes-confluent

SHELL := /bin/bash

.PHONY: help all

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-35s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build docker dev container
	cd .devcontainer && docker build -f Dockerfile . -t $(NAME)

run: ## Run docker dev container
	docker run -it --rm -v "$$(pwd)":/workspaces/$(NAME) -v ~/.kube:/root/.kube -v ~/.cache/pre-commit:/root/.cache/pre-commit -v ~/.terraform.d/plugins:/root/.terraform.d/plugins --workdir /workspaces/$(NAME) $(NAME) /bin/bash

setup: ## Setup project
	# terraform
	terraform init
	cd examples/complete && terraform init
	cd examples/managed_rules && terraform init
	cd examples/rules && terraform init
	cd examples/rules_only && terraform init

	# pre-commit
	git init
	git add -A
	pre-commit install

	# terratest
	rm -rf go.mod*
	go get github.com/gruntwork-io/terratest/modules/terraform
	go mod init test/terraform_complete_test.go
	go mod tidy -go=1.16 && go mod tidy -go=1.17

docs:
	./bin/render-docs.sh

lint: docs ## Lint with pre-commit
	git add -A
	pre-commit run
	git add -A

lint-all: docs ## Lint all files with pre-commit
	git add -A
	pre-commit run --all-files
	git add -A

tests: test-complete test-managed-rules test-custom-rules test-rules-only ## Tests with Terratest

test-complete: ## Test the complete example
	go test test/terraform_complete_test.go -timeout 5m -v |& tee test/terraform_complete_test.log

test-managed-rules: ## Test the managed_rules example
	go test test/terraform_managed_rules_test.go -timeout 5m -v |& tee test/terraform_managed_rules_test.log

test-custom-rules: ## Test the rules example
	go test test/terraform_custom_rules_test.go -timeout 5m -v |& tee test/terraform_custom_rules_test.log

test-rules-only: ## Test the rules_only example
	go test test/terraform_rules_only_test.go -timeout 5m -v |& tee test/terraform_rules_only_test.log

clean: ## Clean project
	@rm -f .terraform.lock.hcl
	@rm -f examples/complete/.terraform.lock.hcl
	@rm -f examples/managed_rules/.terraform.lock.hcl
	@rm -f examples/rules/.terraform.lock.hcl
	@rm -f examples/rules_only/.terraform.lock.hcl

	@rm -rf .terraform
	@rm -rf examples/complete/.terraform
	@rm -rf examples/managed_rules/.terraform
	@rm -rf examples/rules/.terraform
	@rm -rf examples/rules_only/.terraform

	@rm -f go.mod
	@rm -f go.sum
	@rm -f test/go.mod
	@rm -f test/go.sum
