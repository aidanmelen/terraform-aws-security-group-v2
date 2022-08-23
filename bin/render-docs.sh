#!/bin/bash

# render terraform-docs code examples

## examples
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.1.0"/g' examples/complete/main.tf > examples/complete/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.1.0"/g' examples/managed_rules/main.tf > examples/managed_rules/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.1.0"/g' examples/custom_rules/main.tf > examples/custom_rules/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.1.0"/g' examples/rules_only/main.tf > examples/rules_only/.main.tf.docs
# render Makefile targets examples
make > .make.docs

# remove terminal color codes
sed -i 's/\x1b\[[0-9;]*m//g' .make.docs

# remove make header (first line)
sed -i '1d' .make.docs

# remove make footer (last line)
sed -i '$d' .make.docs
