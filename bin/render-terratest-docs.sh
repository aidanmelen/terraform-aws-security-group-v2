#!/bin/bash

# render terratest docs

VERSION=$1
echo "Terratest Suite (v${VERSION})" > test/.terratest.docs

tail -3 test/terraform_basic_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_complete_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_customer_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_managed_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_common_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_matrix_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_computed_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_rules_only_test.log | head -1 >> test/.terratest.docs
