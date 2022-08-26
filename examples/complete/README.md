# Complete Security Group example

Create a security group with a combination of both managed, custom, computed, and auto group rules. This also demonstrates the conditional create functionality.

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
module "sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.4.0"

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

  create_ingress_all_from_self_rule = false # already created with a custom ingress rule
  create_egress_all_to_public_rules = true

  tags = {
    "Name" = local.name
  }
}

################################################################################
# Disabled creation
################################################################################

module "disabled_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.4.0"
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
| <a name="module_sg"></a> [sg](#module\_sg) | ../../ | n/a |
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
| <a name="output_egress_keys"></a> [egress\_keys](#output\_egress\_keys) | The security group egress rules keys. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the security group. |
| <a name="output_ingress"></a> [ingress](#output\_ingress) | The security group ingress rules. |
| <a name="output_ingress_keys"></a> [ingress\_keys](#output\_ingress\_keys) | The security group ingress rules keys. |
| <a name="output_terratest"></a> [terratest](#output\_terratest) | The IDs of uknown aws resource to be used by Terratest. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
