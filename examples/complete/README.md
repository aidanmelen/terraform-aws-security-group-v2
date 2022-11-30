# Security Group with complete rules

Create a AWS Security Group with a broad mix of various features and settings provided by this module:

- customer ingress/egress rules.
- Managed ingress/egress rules (e.g. `all-all`, `postgresql-tcp`, `ssh-tcp`, and `https-443-tcp` just to name a few.). Please see [rules.tf](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/rules.tf) for the complete list of managed rules.
- Common Ingress/Egress for common scenarios sech as `all-all-from-self`, `https-tcp-from-public`, and `all-all-to-public` just to name a few. Please see [rules.tf](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/rules.tf) for the complete list of common rules.
- Computed ingress/egress rules for manage Security Group rules that reference unknown values such as: aws_vpc.vpc.cidr_blocks, aws_security_group.sg.id, etc. Computed rules supports customer, Managed, and Common rules.
- Matrix rules could be used in the complete example but are omitted for the sake of not creating too many example rules. Please see the [Matrix Rules Example] (https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/matrix) for more information.
- Conditionally create security group and/or all required security group rules.

Data sources are used to discover existing VPC resources (VPC, default security group, s3 endpoint prefix list).

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Examples

```hcl
#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 2.1.1"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule        = "all-all"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
      description = "managed rule example"
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
      description              = "customer rule example"
    },
    {
      rule        = "https-tcp-from-public"
      description = "common rule example"
    },
    { rule = "http-tcp-from-public" },
    { rule = "all-all-from-self" }
  ]

  computed_ingress = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
      description              = "This rule must be computed because it is created in the same terraform run as this module and is unknown at plan time."
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
      description = "managed rule example"
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
      description              = "customer rule example"
    },
    {
      rule        = "all-all-to-public"
      description = "common rule example"
    }
  ]

  computed_egress = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
      description     = "computed (customer) rule example"
    },
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
      description     = "computed (managed) rule example"
    }
  ]

  unpack = false

  tags = {
    "Name" = local.name
  }
}

################################################################################
# Export Rule Aliases
################################################################################

resource "aws_security_group" "example" {
  name        = "${local.name}-export-rule-alises"
  description = "Security group rule with exported module rule aliases."
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  description       = module.security_group.rule_aliases.https-443-tcp.description
  from_port         = module.security_group.rule_aliases.https-443-tcp.from_port
  to_port           = module.security_group.rule_aliases.https-443-tcp.to_port
  protocol          = module.security_group.rule_aliases.https-443-tcp.protocol
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.example.id
}

################################################################################
# Disabled creation
################################################################################

module "disabled_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 2.1.1"
  create = false
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_disabled_sg"></a> [disabled\_sg](#module\_disabled\_sg) | ../../ | n/a |
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | ../../ | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region. | `string` | `"us-west-2"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the security group. |
| <a name="output_disabled_sg_id"></a> [disabled\_sg\_id](#output\_disabled\_sg\_id) | The disabled security group IDs. |
| <a name="output_egress"></a> [egress](#output\_egress) | The security group egress rules. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the security group. |
| <a name="output_ingress"></a> [ingress](#output\_ingress) | The security group ingress rules. |
| <a name="output_sg_rule_with_exported_module_rule_alias"></a> [sg\_rule\_with\_exported\_module\_rule\_alias](#output\_sg\_rule\_with\_exported\_module\_rule\_alias) | Security group rule with exported module rule aliases. |
| <a name="output_terratest"></a> [terratest](#output\_terratest) | Outputs used by Terratest. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
