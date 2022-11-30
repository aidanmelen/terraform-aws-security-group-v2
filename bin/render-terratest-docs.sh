#!/bin/bash

# render terratest docs

VERSION=$1
TF_VERSION=$(cat .terraform-version)
echo "Terratest Suite (Module v${VERSION}) (Terraform v${TF_VERSION})" > test/.terratest.docs

tail -3 test/terraform_basic_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_complete_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_customer_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_managed_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_common_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_matrix_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_computed_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_name_prefix_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_rules_only_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_unpack_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_source_security_group_ids_test.log | head -1 >> test/.terratest.docs
