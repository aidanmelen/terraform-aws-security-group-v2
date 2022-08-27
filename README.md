[![Pre-Commit](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml)
[![Terratest](https://img.shields.io/badge/Terratest-enabled-blueviolet)](https://github.com/aidanmelen/terraform-aws-security-group-v2#tests)
[![Tfsec](https://img.shields.io/badge/tfsec-enabled-blue)](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml)

# terraform-aws-security-v2

Terraform module which creates [EC2 security group within VPC](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html) on AWS.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Features

This module aims to implement **ALL** combinations of arguments supported by AWS and latest stable version of Terraform:

- Custom ingress/egress rules.
- Managed ingress/egress rules (e.g. `all-all`, `postgresql-tcp`, `ssh-tcp`, and `https-443-tcp` just to name a few.). Please see [rules.tf](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/rules.tf) for the complete list of managed rules.
- Common Ingress/Egress for common scenarios sech as `all-from-self`, `https-from-public`, and `all-to-public` just to name a few. Please see [rules.tf](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/rules.tf) for the complete list of common rules.
- Computed ingress/egress rules for manage Security Group rules that reference unknown values such as: aws_vpc.vpc.cidr_blocks, aws_security_group.sg.id, etc. Computed rules supports Custom, Managed, and Common rules.
- Conditionally create security group and/or all required security group rules.

What's more, this module was modeled on the [terraform-aws-modules/terraform-aws-security-group](hhttps://github.com/terraform-aws-modules/terraform-aws-security-group#features) module and aims to have feature parody.

## Examples

### Security Group with basic rules

Create a security group using:

- The `https-443-tcp` managed ingress rule
- The `all-from-self` common ingress rule
- The `all-to-public` common egress rule

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = ["10.0.0.0/24"]
      description = "My Private Service"
    },
    { rule = "all-from-self" }
  ]

  egress = [
    { rule = "all-to-public" }
  ]

  tags = {
    "Name" = local.name
  }
}
```

Please see the [Basic Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/basic) for more information.

### Security Group with complete rules

Create a AWS Security Group with a broad mix of various features and settings provided by this module.

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule        = "all-all"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      rule            = "ssh-tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    { rule = "https-from-public" },
    { rule = "http-from-public" },
    { rule = "all-from-self" }
  ]

  computed_ingress = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  egress = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      rule            = "ssh-tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    { rule = "all-to-public" }
  ]

  computed_egress = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    },
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]

  tags = {
    "Name" = local.name
  }
}

################################################################################
# Disabled creation
################################################################################

module "disabled_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"
  create = false
}
```

Please see the [Complete Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/complete) for more information.

### Security Group with common rules

Create security groups with common scenario rules (e.g. `https`, `http`, and `ssh`).

<details><summary>Click to show</summary>

```hcl
module "public_https_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = "${local.name}-https"
  description = "${local.name}-https"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "all-from-https" }, { rule = "all-from-self" }]
  egress  = [{ rule = "all-to-public" }]

  tags = {
    "Name" = "${local.name}-https"
  }
}

module "public_http_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = "${local.name}-http"
  description = "${local.name}-http"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "all-from-http" }, { rule = "all-from-self" }]
  egress  = [{ rule = "all-to-public" }]

  tags = {
    "Name" = "${local.name}-http"
  }
}

module "ssh_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = "${local.name}-ssh"
  description = "${local.name}-ssh"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "ssh-tcp", cidr_blocks = ["10.0.0.0/24"] }, { rule = "all-from-self" }]
  egress  = [{ rule = "all-to-public" }]

  tags = {
    "Name" = "${local.name}-ssh"
  }
}
```

</details><br/>

Please see the [Common Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/common) for more information.

### Security group with custom rules

Create a security group with custom rules.

<details><summary>Click to show</summary>

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      from_port        = 350
      to_port          = 450
      protocol         = "tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
    }
  ]

  egress = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      from_port        = 350
      to_port          = 450
      protocol         = "tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
    }
  ]

  tags = {
    "Name" = local.name
  }
}
```

</details><br/>

Please see the [Custom Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/rules) for more information.

### Security group with managed rules

Create a security group with managed rules.

<details><summary>Click to show</summary>

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule        = "all-all"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      rule            = "ssh-tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      rule                     = "all-icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      rule = "all-all"
      self = true
    }
  ]

  egress = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      rule            = "ssh-tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      rule                     = "all-icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      rule = "all-all"
      self = true
    }
  ]

  tags = {
    "Name" = local.name
  }
}
```

</details><br/>

Please see the [Managed Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/managed) for more information.

### Security group with computed rules

Create a security group with a computed rules. Computed security group rules uses `count` to dynamically create rules with unknown values during the initial Terraform plan. Please see [Limitations on values used in for_each](https://www.terraform.io/language/meta-arguments/for_each#limitations-on-values-used-in-for_each).

<details><summary>Click to show</summary>

```hcl
###############################################################################
# Resources That Must Use Computed Security Group Rules
###############################################################################

resource "aws_security_group" "other" {
  name        = "${local.name}-other"
  description = "${local.name}-other"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-other"
  }
}

resource "aws_ec2_managed_prefix_list" "other" {
  name           = "${local.name}-other"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = data.aws_vpc.default.cidr_block
    description = "Primary"
  }
}

###############################################################################
# Security Group
###############################################################################

module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  computed_ingress = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  computed_egress = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    },
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]

  tags = {
    "Name" = local.name
  }
}
```

</details><br/>

Please see the [Computed Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/computed) for more information.

### Only rules with pre-existing security group

Use the module to create rules for a pre-existing security group.

<details><summary>Click to show</summary>

```hcl
resource "aws_security_group" "pre_existing" {
  name        = "${local.name}-pre-existing"
  description = "${local.name}-pre-existing"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-pre-existing"
  }
}

module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  create_security_group = false
  security_group_id     = aws_security_group.pre_existing.id

  ingress = [{ rule = "https-from-public" }]
  egress  = [{ rule = "all-to-public" }]

  tags = {
    "Name" = local.name
  }
}
```

</details><br/>

Please see the [Rules Only Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/rules_only) for more information.

## Tests

Run Terratest using the [Makefile](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/Makefile) targets:
1. `make setup`
2. `make tests`

### Results

```
--- PASS: TestTerraformBasicExample (24.15s)
--- PASS: TestTerraformCompleteExample (48.83s)
--- PASS: TestTerraformCustomRulesExample (33.22s)
--- PASS: TestTerraformManagedRulesExample (33.45s)
--- PASS: TestTerraformComputedRulesExample (30.26s)
--- PASS: TestTerraformdRulesOnlyExample (20.30s)
```

## Makefile Targets

```
help                 This help.
build                Build docker dev image
run                  Run docker dev container
setup                Setup project
lint                 Lint with pre-commit and render docs
lint-all             Lint all files with pre-commit and render docs
tests                Tests with Terratest
test-basic           Test the basic example
test-complete        Test the complete example
test-custom          Test the custom example
test-managed         Test the managed example
test-computed        Test the computed example
test-rules-only      Test the rules_only example
clean                Clean project
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29 |
## Resources

| Name | Type |
|------|------|
| [aws_security_group.self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.computed_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.computed_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_computed_egress"></a> [computed\_egress](#input\_computed\_egress) | The security group egress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either custom, managed, or common rule. | `any` | `[]` | no |
| <a name="input_computed_ingress"></a> [computed\_ingress](#input\_computed\_ingress) | The security group ingress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either custom, managed, or common rule. | `any` | `[]` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group and all rules | `bool` | `true` | no |
| <a name="input_create_security_group"></a> [create\_security\_group](#input\_create\_security\_group) | Whether to create security group and all rules. | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | Time to wait for a security group to be created. | `string` | `"10m"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | Time to wait for a security group to be deleted. | `string` | `"15m"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional, Forces new resource) Security group description. Defaults to Managed by Terraform. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags. | `string` | `null` | no |
| <a name="input_egress"></a> [egress](#input\_egress) | The security group egress rules. Can be either custom, managed, or common rule. | `any` | `[]` | no |
| <a name="input_ingress"></a> [ingress](#input\_ingress) | The security group ingress rules. Can be either custom, managed, or common rule. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional, Forces new resource) Name of the security group. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name. | `string` | `null` | no |
| <a name="input_revoke_rules_on_delete"></a> [revoke\_rules\_on\_delete](#input\_revoke\_rules\_on\_delete) | (Optional) Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. Default false. | `string` | `null` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | ID of existing security group whose rules we will manage. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional, Forces new resource) VPC ID. | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | The security group attributes. |
| <a name="output_security_group_egress_rules"></a> [security\_group\_egress\_rules](#output\_security\_group\_egress\_rules) | The security group egress rules. |
| <a name="output_security_group_ingress_rules"></a> [security\_group\_ingress\_rules](#output\_security\_group\_ingress\_rules) | The security group ingress rules. |

## Acknowledgments

This modules aims to improve on the venerable [terraform-aws-modules/terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group) module authored by [Anton Babenko](https://github.com/antonbabenko). It does so by:

- Reduce amount of code with [`for` expressions](https://www.terraform.io/language/expressions/for).
- Follow DRY principals by using [Conditionally Omitted Arguments](https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements#conditionally-omitted-arguments).
- Dynamically create custom and managed security group rule resources with [`for_each` meta-arguments](https://www.terraform.io/language/meta-arguments/for_each). This has 2 advantages over `count`:
1. The terraform resource IDs are descriptive rather than indexes with `count`.
2. Adding/Removing or even reordering rules can causes the count indexes to change possibly resulting in unwanted destruction and recreation of resources. Whereas `for_each` with map inputs use identifiable keys and do not suffer from this constraint.
- Computed security group rule resources still must still use `count` due to [Limitations on values used in `for_each`](https://www.terraform.io/language/meta-arguments/for_each#limitations-on-values-used-in-for_each). However, this implementation uses the `length()` function to dynamically set the `count` rather than relying on the user to provided `number_of_computed` variables. [When to Use for_each Instead of count](https://www.terraform.io/language/meta-arguments/count#when-to-use-for_each-instead-of-count).
- Encourage the security best practice of restrictive rules by making users **opt-in** to common rules like `create_egress_all_to_public_rules`. Please see [no-public-egress-sgr](https://aquasecurity.github.io/tfsec/v0.61.3/checks/aws/vpc/no-public-egress-sgr/) for more information.
- Improve security by having users declare granular custom or managed security group rules.
- Test examples with [Terratest](https://terratest.gruntwork.io/).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
