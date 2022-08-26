#!/bin/bash

# render terraform-docs code examples

sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.0"/g' examples/basic/main.tf > examples/basic/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.0"/g' examples/complete/main.tf > examples/complete/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.0"/g' examples/common_rules/main.tf > examples/common_rules/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.0"/g' examples/custom_rules/main.tf > examples/custom_rules/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.0"/g' examples/managed_rules/main.tf > examples/managed_rules/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.0"/g' examples/computed_rules/main.tf > examples/computed_rules/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.0"/g' examples/rules_only/main.tf > examples/rules_only/.main.tf.docs
