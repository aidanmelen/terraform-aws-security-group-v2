[![Pre-Commit](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/aidanmelen/terraform-aws-security-group-v2/actions/workflows/pre-commit.yaml)
[![Terratest](https://img.shields.io/badge/Terratest-enabled-blueviolet)](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/test)

# terraform-aws-security-v2

Terraform module which creates [EC2 security group within VPC](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html) on AWS.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Examples

### Complete

Please see the [Complete Example](examples/complete) for more information.

### Security group with managed rules

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

Please see the [Managed Rules Example](examples/managed_rules) for more information.

### Security group with custom rules

```hcl
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = [
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      protocol         = "tcp"
      from_port        = 350
      to_port          = 450
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      protocol        = "tcp"
      from_port       = 22
      to_port         = 22
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      protocol                 = "icmp"
      from_port                = -1
      to_port                  = -1
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      protocol  = "-1"
      from_port = -1
      to_port   = -1
      self      = true
    }
  ]

  egress_rules = [
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      protocol         = "tcp"
      from_port        = 350
      to_port          = 450
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      protocol        = "tcp"
      from_port       = 22
      to_port         = 22
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
    {
      protocol                 = "icmp"
      from_port                = -1
      to_port                  = -1
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      protocol  = "-1"
      from_port = -1
      to_port   = -1
      self      = true
    }
  ]

  tags = {
    "Name" = local.name
  }
}
```

Please see the [Custom Rules Example](examples/rules) for more information.

### Only rules with pre-existing security group

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

Please see the [Rules Only Example](examples/rules_only) for more information.

## Limitations

The following module security group rule arguments must be known before the first Terraform apply:

- `cidr_blocks`
- `ipv6_cidr_blocks`
- `prefix_list_ids`
- `source_security_group_id`

They can be dynamic after the first Terraform apply.

## Tests

Run Terratest using the [Makefile](./Makefile) targets:
1. `make setup`
2. `make tests`

### Results

```
--- PASS: TestTerraformCompleteExample (33.57s)
--- PASS: TestTerraformCustomRulesExample (31.41s)
--- PASS: TestTerraformManagedRulesExample (32.16s)
--- PASS: TestTerraformRulesOnlyExample (18.84s)
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
test-complete        Test the complete example
test-managed-rules   Test the managed_rules example
test-custom-rules    Test the custom_rules example
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
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group and all rules | `bool` | `true` | no |
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
| <a name="output_egress_rule_ids"></a> [egress\_rule\_ids](#output\_egress\_rule\_ids) | The security group rule IDs. |
| <a name="output_egress_rule_keys"></a> [egress\_rule\_keys](#output\_egress\_rule\_keys) | The egress security group rule keys. |
| <a name="output_ingress_rule_ids"></a> [ingress\_rule\_ids](#output\_ingress\_rule\_ids) | The security group rule IDs. |
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
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
