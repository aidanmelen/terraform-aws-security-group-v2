[![Pre-Commit](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml)
[![Terratest](https://img.shields.io/badge/Terratest-enabled-blueviolet)](https://github.com/aidanmelen/terraform-aws-security-group-v2#tests)
[![Tfsec](https://img.shields.io/badge/tfsec-enabled-blue)](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml)

# terraform-aws-security-v2

Terraform module which creates [EC2 security group within VPC](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html) on AWS.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Features

This module aims to implement **ALL** combinations of arguments supported by AWS and latest stable version of Terraform:

- IPv4/IPv6 CIDR blocks
- [VPC endpoint prefix lists](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-endpoints.html) (use data source [aws_prefix_list](https://www.terraform.io/docs/providers/aws/d/prefix_list.html))
- Access from source security groups
- Access from self
- Named rules ([see the rules here](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/rules.tf))
<!-- - Named groups of rules with ingress (inbound) and egress (outbound) ports open for common scenarios (eg, [ssh](https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/modules/ssh), [http-80](https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/modules/http-80), [mysql](https://github.com/terraform-aws-modules/terraform-aws-security-group/tree/master/modules/mysql), see the whole list [here](https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/modules/README.md)) -->
- Conditionally create security group and/or all required security group rules.
- Toggle creation of common egress to public internet IVP4/IPV6 rules.

## Examples

### Security Group with basic rules

Create a security group with HTTPS from `10.0.0.0/24` and `all-all` to the public internet rules.

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [
    {
      rule        = "https-443-tcp"
      description = "My Service"
      cidr_blocks = ["10.0.0.0/24"]
    }
  ]

  create_auto_group_ingress_all_from_self_rules         = true
  create_auto_group_egress_all_to_public_internet_rules = true

  tags = {
    "Name" = local.name
  }
}
```

Please see the [Basic Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/basic) for more information.

### Security Group with complete rules

Create a security group with a combination of both managed and custom rules. This also demonstrates the conditional create functionality.

<details><summary>Click to show</summary>

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [
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
    }
  ]

  ingress_rules = [
    {
      from_port                = -1
      to_port                  = -1
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      self      = true
    }
  ]

  managed_egress_rules = [
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
    }
  ]

  egress_rules = [
    {
      from_port                = -1
      to_port                  = -1
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      self      = true
    }
  ]

  computed_ingress_rules = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  computed_egress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]

  computed_managed_ingress_rules = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  computed_managed_egress_rules = [
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]

  create_auto_group_ingress_all_from_self_rules         = true
  create_auto_group_egress_all_to_public_internet_rules = true

  tags = {
    "Name" = local.name
  }
}

################################################################################
# Disabled creation
################################################################################

module "disabled_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.1.0"
  create = false
}
```

</details><br/>

Please see the [Complete Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/complete) for more information.

### Security group with custom rules

Create a security group with custom rules.

<details><summary>Click to show</summary>

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = [
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
      from_port                = -1
      to_port                  = -1
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      self      = true
    }
  ]

  egress_rules = [
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
      from_port                = -1
      to_port                  = -1
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = -1
      to_port   = -1
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
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [
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

  managed_egress_rules = [
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

Please see the [Managed Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/managed_rules) for more information.

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
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  computed_ingress_rules = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  computed_egress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]

  computed_managed_ingress_rules = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  computed_managed_egress_rules = [
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

Please see the [Computed Rules Example](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/computed_rules) for more information.

### Only rules with pre-existing security group

Use the module to create rules for a pre-existing security group.

<details><summary>Click to show</summary>

```hcl
resource "aws_security_group" "pre_existing_sg" {
  name        = "${local.name}-pre-existing-sg"
  description = "${local.name}-pre-existing-sg"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-pre-existing-sg"
  }
}

module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.1.0"

  create_sg         = false
  security_group_id = aws_security_group.pre_existing_sg.id

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  managed_ingress_rules = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = data.aws_security_group.default.id
    }
  ]

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
--- PASS: TestTerraformBasicExample (24.72s)
--- PASS: TestTerraformCompleteExample (48.69s)
--- PASS: TestTerraformCustomRulesExample (36.72s)
--- PASS: TestTerraformManagedRulesExample (37.11s)
--- PASS: TestTerraformComputedRulesExample (33.16s)
--- PASS: TestTerraformRulesOnlyExample (23.53s)
```

## Makefile Targets

```
help                 This help.
build                Build docker dev image
run                  Run docker dev container
setup                Setup project
lint                 Lint with pre-commit
lint-all             Lint all files with pre-commit
tests                Tests with Terratest
test-basic           Test the basic example
test-complete        Test the complete example
test-custom-rules    Test the custom_rules example
test-managed-rules   Test the managed_rules example
test-computed-rules  Test the computed_rules example
test-rules-only      Test the rules_only example
clean                Clean project
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_computed_egress_rules"></a> [computed\_egress\_rules](#input\_computed\_egress\_rules) | List of dynamic egress rules. The key is the rule description and the value are the `aws_security_group_rule` resource arguments. | `any` | `[]` | no |
| <a name="input_computed_ingress_rules"></a> [computed\_ingress\_rules](#input\_computed\_ingress\_rules) | List of dynamic ingress rules. The key is the rule description and the value are the `aws_security_group_rule` resource arguments. | `any` | `[]` | no |
| <a name="input_computed_managed_egress_rules"></a> [computed\_managed\_egress\_rules](#input\_computed\_managed\_egress\_rules) | List of dynamic managed egress rules. The key is the rule description and the value is the managed rule name. | `any` | `[]` | no |
| <a name="input_computed_managed_ingress_rules"></a> [computed\_managed\_ingress\_rules](#input\_computed\_managed\_ingress\_rules) | List of dynamic managed ingress rules. The key is the rule description and the value is the managed rule name. | `any` | `[]` | no |
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group and all rules | `bool` | `true` | no |
| <a name="input_create_auto_group_egress_all_to_public_internet_rules"></a> [create\_auto\_group\_egress\_all\_to\_public\_internet\_rules](#input\_create\_auto\_group\_egress\_all\_to\_public\_internet\_rules) | Whether to create auto group egress all to public internet rules (IPV4/IPV6). | `bool` | `false` | no |
| <a name="input_create_auto_group_ingress_all_from_self_rules"></a> [create\_auto\_group\_ingress\_all\_from\_self\_rules](#input\_create\_auto\_group\_ingress\_all\_from\_self\_rules) | Whether to create auto group ingress all to self rules. | `bool` | `false` | no |
| <a name="input_create_sg"></a> [create\_sg](#input\_create\_sg) | Whether to create security group and all rules. | `bool` | `true` | no |
| <a name="input_create_timeout"></a> [create\_timeout](#input\_create\_timeout) | Time to wait for a security group to be created. | `string` | `"10m"` | no |
| <a name="input_delete_timeout"></a> [delete\_timeout](#input\_delete\_timeout) | Time to wait for a security group to be deleted. | `string` | `"15m"` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional, Forces new resource) Security group description. Defaults to Managed by Terraform. Cannot be "". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags. | `string` | `null` | no |
| <a name="input_egress_rules"></a> [egress\_rules](#input\_egress\_rules) | List of egress rules. The key is the rule description and the value are the `aws_security_group_rule` resource arguments. | `any` | `[]` | no |
| <a name="input_ingress_rules"></a> [ingress\_rules](#input\_ingress\_rules) | List of ingress rules. The key is the rule description and the value are the `aws_security_group_rule` resource arguments. | `any` | `[]` | no |
| <a name="input_managed_egress_rules"></a> [managed\_egress\_rules](#input\_managed\_egress\_rules) | List of managed egress rules. The key is the rule description and the value is the managed rule name. | `any` | `[]` | no |
| <a name="input_managed_ingress_rules"></a> [managed\_ingress\_rules](#input\_managed\_ingress\_rules) | List of managed ingress rules. The key is the rule description and the value is the managed rule name. | `any` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional, Forces new resource) Name of the security group. If omitted, Terraform will assign a random, unique name. | `string` | `null` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | (Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name. | `string` | `null` | no |
| <a name="input_revoke_rules_on_delete"></a> [revoke\_rules\_on\_delete](#input\_revoke\_rules\_on\_delete) | (Optional) Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. Default false. | `string` | `null` | no |
| <a name="input_security_group_id"></a> [security\_group\_id](#input\_security\_group\_id) | ID of existing security group whose rules we will manage. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) Map of tags to assign to the resource. If configured with a provider default\_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level. | `map(string)` | `null` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | (Optional, Forces new resource) VPC ID. | `string` | `null` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_auto_group_egress_all_to_public_internet_rule_keys"></a> [auto\_group\_egress\_all\_to\_public\_internet\_rule\_keys](#output\_auto\_group\_egress\_all\_to\_public\_internet\_rule\_keys) | The auto group egress all to public internet rule keys. |
| <a name="output_auto_group_egress_to_public_internet_rule_ids"></a> [auto\_group\_egress\_to\_public\_internet\_rule\_ids](#output\_auto\_group\_egress\_to\_public\_internet\_rule\_ids) | The auto group egress all to public internet rule IDs. |
| <a name="output_auto_group_ingress_all_from_self_rule_ids"></a> [auto\_group\_ingress\_all\_from\_self\_rule\_ids](#output\_auto\_group\_ingress\_all\_from\_self\_rule\_ids) | The auto group ingress all to self rule IDs. |
| <a name="output_auto_group_ingress_all_from_self_rule_keys"></a> [auto\_group\_ingress\_all\_from\_self\_rule\_keys](#output\_auto\_group\_ingress\_all\_from\_self\_rule\_keys) | The auto group ingress all to self rule key. |
| <a name="output_computed_egress_rule_ids"></a> [computed\_egress\_rule\_ids](#output\_computed\_egress\_rule\_ids) | The computed egress security group rule IDs. |
| <a name="output_computed_ingress_rule_ids"></a> [computed\_ingress\_rule\_ids](#output\_computed\_ingress\_rule\_ids) | The computed ingress security group rule IDs. |
| <a name="output_computed_managed_egress_rule_ids"></a> [computed\_managed\_egress\_rule\_ids](#output\_computed\_managed\_egress\_rule\_ids) | The computed managed egress security group rule IDs. |
| <a name="output_computed_managed_ingress_rule_ids"></a> [computed\_managed\_ingress\_rule\_ids](#output\_computed\_managed\_ingress\_rule\_ids) | The computed managed ingress security group rule IDs. |
| <a name="output_egress_rule_ids"></a> [egress\_rule\_ids](#output\_egress\_rule\_ids) | The egress security group rule IDs. |
| <a name="output_egress_rule_keys"></a> [egress\_rule\_keys](#output\_egress\_rule\_keys) | The egress security group rule keys. |
| <a name="output_ingress_rule_ids"></a> [ingress\_rule\_ids](#output\_ingress\_rule\_ids) | The ingress security group rule IDs. |
| <a name="output_ingress_rule_keys"></a> [ingress\_rule\_keys](#output\_ingress\_rule\_keys) | The ingress security group rule keys. |
| <a name="output_managed_egress_rule_ids"></a> [managed\_egress\_rule\_ids](#output\_managed\_egress\_rule\_ids) | The managed egress security group rule IDs. |
| <a name="output_managed_egress_rule_keys"></a> [managed\_egress\_rule\_keys](#output\_managed\_egress\_rule\_keys) | The managed egress security group rule keys. |
| <a name="output_managed_ingress_rule_ids"></a> [managed\_ingress\_rule\_ids](#output\_managed\_ingress\_rule\_ids) | The managed ingress security group rule IDs. |
| <a name="output_managed_ingress_rule_keys"></a> [managed\_ingress\_rule\_keys](#output\_managed\_ingress\_rule\_keys) | The managed ingress security group rule keys. |
| <a name="output_security_group_arn"></a> [security\_group\_arn](#output\_security\_group\_arn) | The ARN of the security group |
| <a name="output_security_group_description"></a> [security\_group\_description](#output\_security\_group\_description) | The description of the security group |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_security_group_name"></a> [security\_group\_name](#output\_security\_group\_name) | The name of the security group |
| <a name="output_security_group_owner_id"></a> [security\_group\_owner\_id](#output\_security\_group\_owner\_id) | The owner ID |
| <a name="output_security_group_vpc_id"></a> [security\_group\_vpc\_id](#output\_security\_group\_vpc\_id) | The VPC ID |

## Acknowledgments

This modules aims to improve on the venerable [terraform-aws-modules/terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group) module authored by [Anton Babenko](https://github.com/antonbabenko). It does so by:

- Reduce amount of code with [`for` expressions](https://www.terraform.io/language/expressions/for).
- Follow DRY principals by using [Conditionally Omitted Arguments](https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements#conditionally-omitted-arguments).
- Dynamically create custom and managed security group rule resources [`for_each` meta-arguments](https://www.terraform.io/language/meta-arguments/for_each). This has 2 advantages over `count`:
1. The terraform resource IDs are descriptive rather than indexes with `count`.
2. Adding/Removing or even reordering rules can causes the count indexes to change possibly resulting in unwanted destruction and recreation of resources. Whereas `for_each` with map inputs use identifiable keys and do not suffer from this constraint.
- Computed security group rule resources still must still use `count` due to [Limitations on values used in `for_each`](https://www.terraform.io/language/meta-arguments/for_each#limitations-on-values-used-in-for_each). However, this implementation of `count` dynamically uses the `length()` function rather than relying on the user to provided `number_of_computed` variables. [When to Use for_each Instead of count](https://www.terraform.io/language/meta-arguments/count#when-to-use-for_each-instead-of-count).
- Improve security by declaring granular security group rules. Use [AWS Prefix Lists](https://docs.aws.amazon.com/vpc/latest/userguide/managed-prefix-lists.html) to apply rules to many IPV4/IPV6 CIDRs or use the `for` expression with computed rules for other rule resources.
- Test examples with [Terratest](https://terratest.gruntwork.io/).

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
