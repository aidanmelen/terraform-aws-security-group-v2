# Unpack Security Group Rules

A single `aws_security_group_rule` resource can result in one or many security group rules being created by the EC2 API. When unpacking is enabled, `aws_security_group_rule` resource arguments supplied by the user will be unpacked such that each resource is guaranteed to result in the EC2 API creating exactly one rule. This prevents the side-effect of a single rule update causing many other unwanted updates during the replacement.

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
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      from_port                = "22"
      to_port                  = "22"
      protocol                 = "TCP"
      cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
      ipv6_cidr_blocks         = ["2001:db8::/64"]
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "unpack customer rules."
    },
    {
      rule                     = "postgresql-tcp"
      cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
      ipv6_cidr_blocks         = ["2001:db8::/64"]
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "unpack managed rules"
    },
    {
      rule        = "https-from-public"
      description = "unpack common rule."
    },
  ]

  matrix_ingress = {
    rules = [
      {
        from_port   = 25
        to_port     = 25
        protocol    = "tcp"
        description = "unpack matrix customer rule"
      },
      {
        rule        = "mysql-tcp"
        description = "unpack matrix managed rule"
      },
    ],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    ipv6_cidr_blocks         = []
    prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
    source_security_group_id = data.aws_security_group.default.id
    self                     = true
  }

  # ommitted for the sake of not creating 31 more example egress rules
  # egress = [
  #   {
  #     from_port                = "22"
  #     to_port                  = "22"
  #     protocol                 = "TCP"
  #     cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
  #     ipv6_cidr_blocks         = ["2001:db8::/64"]
  #     prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
  #     source_security_group_id = data.aws_security_group.default.id
  #     self                     = true
  #     description              = "unpack customer rules"
  #   },
  #   {
  #     rule                     = "postgresql-tcp"
  #     cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
  #     ipv6_cidr_blocks         = ["2001:db8::/64"]
  #     prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
  #     source_security_group_id = data.aws_security_group.default.id
  #     self                     = true
  #     description              = "unpack managed rules"
  #   },
  # ]

  # matrix_egress = {
  #   rules = [
  #     {
  #       from_port   = 25
  #       to_port     = 25
  #       protocol    = "tcp"
  #       description = "unpack customer rule"
  #     },
  #     {
  #       rule        = "mysql-tcp"
  #       description = "unpack managed rule"
  #     },
  #     {
  #       rule        = "http-from-public"
  #       description = "unpack common rule"
  #     },
  #   ],
  #   cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
  #   ipv6_cidr_blocks         = []
  #   prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
  #   source_security_group_id = data.aws_security_group.default.id
  #   self                     = true
  # }

  unpack = true
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
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | ../../ | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region. | `string` | `"us-west-2"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the security group. |
| <a name="output_egress"></a> [egress](#output\_egress) | The security group egress rules. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the security group. |
| <a name="output_ingress"></a> [ingress](#output\_ingress) | The security group ingress rules. |
| <a name="output_terratest"></a> [terratest](#output\_terratest) | The IDs of unknown aws resources to be used by Terratest. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
