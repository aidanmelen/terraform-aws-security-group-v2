#!/bin/bash

# render terraform-docs code examples

NAME=$1
HOSTNAME=$2
PROVIDER=$3
VERSION=$4

PATTERN="s/source = [^\r\n]*/source  = \"$HOSTNAME\/$NAME\/$PROVIDER\"\n  version = \">= $VERSION\"/g"

sed -z "${PATTERN}" examples/basic/main.tf > examples/basic/.main.tf.docs
sed -z "${PATTERN}" examples/complete/main.tf > examples/complete/.main.tf.docs
sed -z "${PATTERN}" examples/customer/main.tf > examples/customer/.main.tf.docs
sed -z "${PATTERN}" examples/managed/main.tf > examples/managed/.main.tf.docs
sed -z "${PATTERN}" examples/common/main.tf > examples/common/.main.tf.docs
sed -z "${PATTERN}" examples/matrix/main.tf > examples/matrix/.main.tf.docs
sed -z "${PATTERN}" examples/computed/main.tf > examples/computed/.main.tf.docs
sed -z "${PATTERN}" examples/rules_only/main.tf > examples/rules_only/.main.tf.docs
sed -z "${PATTERN}" examples/name_prefix/main.tf > examples/name_prefix/.main.tf.docs
sed -z "${PATTERN}" examples/unpack/main.tf > examples/unpack/.main.tf.docs
