#!/bin/bash

# render terratest docs

tail -3 test/terraform_basic_test.log | head -1 > test/.terratest.docs
tail -3 test/terraform_complete_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_custom_rules_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_managed_rules_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_computed_rules_test.log | head -1 >> test/.terratest.docs
tail -3 test/terraform_rules_only_test.log | head -1 >> test/.terratest.docs
