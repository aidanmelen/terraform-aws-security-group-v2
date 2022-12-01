NAME := security-group-v2
HOSTNAME := aidanmelen
PROVIDER := aws
VERSION := 2.1.2
SHELL := /bin/bash

.PHONY: help all

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build docker dev image
	cd .devcontainer && docker build -f Dockerfile . -t $(NAME)

run: ## Run docker dev container
	docker run -it --rm -v "$$(pwd)":/workspaces/$(NAME) -v ~/.kube:/root/.kube -v ~/.cache/pre-commit:/root/.cache/pre-commit -v ~/.terraform.d/plugins:/root/.terraform.d/plugins --workdir /workspaces/$(NAME) $(NAME) /bin/bash

setup: ## Setup project
	# terraform
	terraform init
	cd modules/null_unpack_rules && terraform init
	cd modules/null_repack_matrix_rules && terraform init
	cd modules/null_unpack_rules/examples/basic && terraform init
	cd modules/null_repack_matrix_rules/examples/basic && terraform init
	cd examples/basic && terraform init
	cd examples/complete && terraform init
	cd examples/customer && terraform init
	cd examples/managed && terraform init
	cd examples/common && terraform init
	cd examples/matrix && terraform init
	cd examples/computed && terraform init
	cd examples/rules_only && terraform init
	cd examples/name_prefix && terraform init
	cd examples/unpack && terraform init
	cd examples/source_security_group_ids && terraform init

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
	./bin/render-terraform-docs.sh $(NAME) $(HOSTNAME) $(PROVIDER) $(VERSION)
	./bin/render-terratest-docs.sh $(VERSION)
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

tests: test-basic test-complete test-customer test-managed test-common test-computed test-matrix test-rules-only test-name-prefix test-unpack test-source-security-group-ids ## Tests with Terratest

test-basic: ## Test the basic example
	go test test/terraform_basic_test.go -timeout 5m -v |& tee test/terraform_basic_test.log

test-complete: ## Test the complete example
	go test test/terraform_complete_test.go -timeout 5m -v |& tee test/terraform_complete_test.log

test-customer: ## Test the customer example
	go test test/terraform_customer_test.go -timeout 5m -v |& tee test/terraform_customer_test.log

test-managed: ## Test the managed example
	go test test/terraform_managed_test.go -timeout 5m -v |& tee test/terraform_managed_test.log

test-common: ## Test the common example
	go test test/terraform_common_test.go -timeout 5m -v |& tee test/terraform_common_test.log

test-matrix: ## Test the matrix example
	go test test/terraform_matrix_test.go -timeout 5m -v |& tee test/terraform_matrix_test.log

test-computed: ## Test the computed example
	go test test/terraform_computed_test.go -timeout 5m -v |& tee test/terraform_computed_test.log

test-rules-only: ## Test the rules_only example
	go test test/terraform_rules_only_test.go -timeout 5m -v |& tee test/terraform_rules_only_test.log

test-name-prefix: ## Test the name_prefix example
	go test test/terraform_name_prefix_test.go -timeout 5m -v |& tee test/terraform_name_prefix_test.log

test-unpack: ## Test the unpack example
	go test test/terraform_unpack_test.go -timeout 5m -v |& tee test/terraform_unpack_test.log

test-source-security-group-ids: ## Test the source_security_group_ids example
	go test test/terraform_source_security_group_ids_test.go -timeout 5m -v |& tee test/terraform_source_security_group_ids_test.log

release:
	git tag v${VERSION}
	git push --tag

clean: ## Clean project
	@rm -f .terraform.lock.hcl
	@rm -f modules/null_unpack_rules/.terraform.lock.hcl
	@rm -f modules/null_repack_matrix_rules/.terraform.lock.hcl
	@rm -f modules/null_unpack_rules/examples/basic/.terraform.lock.hcl
	@rm -f modules/null_repack_matrix_rules/examples/basic/.terraform.lock.hcl
	@rm -f examples/basic/.terraform.lock.hcl
	@rm -f examples/complete/.terraform.lock.hcl
	@rm -f examples/customer/.terraform.lock.hcl
	@rm -f examples/managed/.terraform.lock.hcl
	@rm -f examples/common/.terraform.lock.hcl
	@rm -f examples/matrix/.terraform.lock.hcl
	@rm -f examples/computed/.terraform.lock.hcl
	@rm -f examples/rules_only/.terraform.lock.hcl
	@rm -f examples/name_prefix/.terraform.lock.hcl
	@rm -f examples/unpack/.terraform.lock.hcl

	@rm -rf .terraform
	@rm -rf modules/null_unpack_rules/.terraform
	@rm -rf modules/null_repack_matrix_rules/.terraform
	@rm -rf modules/null_unpack_rules/examples/basic/.terraform
	@rm -rf modules/null_repack_matrix_rules/examples/basic/.terraform
	@rm -rf examples/basic/.terraform
	@rm -rf examples/complete/.terraform
	@rm -rf examples/customer/.terraform
	@rm -rf examples/managed/.terraform
	@rm -rf examples/common/.terraform
	@rm -rf examples/matrix/.terraform
	@rm -rf examples/computed/.terraform
	@rm -rf examples/rules_only/.terraform
	@rm -rf examples/name_prefix/.terraform
	@rm -rf examples/unpack/.terraform

	@rm -f go.mod
	@rm -f go.sum
	@rm -f test/go.mod
	@rm -f test/go.sum
