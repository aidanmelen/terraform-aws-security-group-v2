#!/bin/bash

# render terraform-docs code examples

sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.1"/g' examples/basic/main.tf > examples/basic/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.1"/g' examples/complete/main.tf > examples/complete/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.1"/g' examples/common/main.tf > examples/common/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.1"/g' examples/custom/main.tf > examples/custom/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.1"/g' examples/managed/main.tf > examples/managed/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.1"/g' examples/computed/main.tf > examples/computed/.main.tf.docs
sed -z 's/source = [^\r\n]*/source  = "aidanmelen\/security-group-v2\/aws"\n  version = ">= 0.5.1"/g' examples/rules_only/main.tf > examples/rules_only/.main.tf.docs
