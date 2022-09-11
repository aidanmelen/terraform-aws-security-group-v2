NAME = terraform-kubernetes-confluent

SHELL := /bin/bash

.PHONY: help all

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build docker dev image
	cd .devcontainer && docker build -f Dockerfile . -t $(NAME)

run: ## Run docker dev container
	docker run -it --rm -v "$$(pwd)":/workspaces/$(NAME) -v ~/.kube:/root/.kube -v ~/.cache/pre-commit:/root/.cache/pre-commit -v ~/.terraform.d/plugins:/root/.terraform.d/plugins --workdir /workspaces/$(NAME) $(NAME) /bin/bash

setup: ## Setup project
	# terraform
	terraform init
	cd examples/basic && terraform init
	cd examples/complete && terraform init
	cd examples/customer && terraform init
	cd examples/managed && terraform init
	cd examples/common && terraform init
	cd examples/matrix && terraform init
	cd examples/computed && terraform init
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
	./bin/render-terraform-docs.sh
	./bin/render-terratest-docs.sh
	./bin/render-makefile-docs.sh
	./bin/scrub-terratest-logs.sh

lint: docs ## Lint with pre-commit and render docs
	git add -A
	pre-commit run
	git add -A

lint-all: docs ## Lint all files with pre-commit and render docs
	git add -A
	pre-commit run --all-files
	git add -A

tests: test-basic test-complete test-customer test-managed test-computed test-rules-only lint ## Tests with Terratest

test-basic: ## Test the basic example
	go test test/terraform_basic_test.go -timeout 5m -v |& tee test/terraform_basic_test.log

test-complete: ## Test the complete example
	go test test/terraform_complete_test.go -timeout 5m -v |& tee test/terraform_complete_test.log

test-customer: ## Test the customer example
	go test test/terraform_customer_test.go -timeout 5m -v |& tee test/terraform_customer_test.log

test-managed: ## Test the managed example
	go test test/terraform_managed_test.go -timeout 5m -v |& tee test/terraform_managed_test.log

test-computed: ## Test the computed example
	go test test/terraform_computed_test.go -timeout 5m -v |& tee test/terraform_computed_test.log

test-rules-only: ## Test the rules_only example
	go test test/terraform_rules_only_test.go -timeout 5m -v |& tee test/terraform_rules_only_test.log

clean: ## Clean project
	@rm -f .terraform.lock.hcl
	@rm -f examples/basic/.tebasiclock.hcl
	@rm -f examples/complete/.tebasiclock.hcl
	@rm -f examples/customer/.terraform.lock.hcl
	@rm -f examples/managed/.terraform.lock.hcl
	@rm -f examples/common/.terraform.lock.hcl
	@rm -f examples/matrix/.terraform.lock.hcl
	@rm -f examples/computed/.terraform.lock.hcl
	@rm -f examples/rules_only/.terraform.lock.hcl

	@rm -rf .terraform
	@rm -rf examples/basic/.terraform
	@rm -rf examples/complete/.terraform
	@rm -rf examples/customer/.terraform
	@rm -rf examples/managed/.terraform
	@rm -rf examples/common/.terraform
	@rm -rf examples/matrix/.terraform
	@rm -rf examples/computed/.terraform
	@rm -rf examples/rules_only/.terraform

	@rm -f go.mod
	@rm -f go.sum
	@rm -f test/go.mod
	@rm -f test/go.sum
