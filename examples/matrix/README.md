# Security Group with matrix rules

Create a security group with matrix rules.

## Details

The input of

```
matrix_ingress = {
  rules = [
    {
      rule = "https-443-tcp"
    },
    {
      from_port = 80
      to_port   = 80
      protocol  = "tcp"
    }
  ],
  cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
  ipv6_cidr_blocks = []
  prefix_list_ids = ["pl-1111111111", "pl-2222222222"]
  source_security_group_id = "sg-1111111111"
  self = true
}
```

will create 6 security group rules (see table below):

| **rule** | **cidr_blocks** | **ipv6_cidr_blocks** | **prefix_list_ids** | **source_security_group_id** | **self** |
|---|---|---|---|---|---|
| `rule = "https-443-tcp"` | `["10.0.0.0/24", "10.0.1.0/24"]` | `[]` | `["pl-1111111111", "pl-2222222222"]` |  |  |
| `rule = "https-443-tcp"` |  |  |  | `"sg-1111111111"` |  |
| `rule = "https-443-tcp"` |  |  |  |  | `true` |
| `from_port = 80` `to_port = 80` `protocol = "tcp"` | `["10.0.0.0/24", "10.0.1.0/24"]` | `[]` | `["pl-1111111111", "pl-2222222222"]` |  |  |
| `from_port = 80` `to_port = 80` `protocol = "tcp"` |  |  |  | `"sg-1111111111"` |  |
| `from_port = 80` `to_port = 80` `protocol = "tcp"` |  |  |  |  | `true` |


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
module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.7.0"

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  matrix_ingress = {
    rules = [
      { rule = "https-443-tcp" },
      { rule = "http-80-tcp" },
    ],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    ipv6_cidr_blocks         = []
    prefix_list_ids          = [aws_ec2_managed_prefix_list.other.id]
    source_security_group_id = aws_security_group.other.id
    self                     = true
  }

  matrix_egress = {
    rules                    = [{ rule = "https-443-tcp" }],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    source_security_group_id = aws_security_group.other.id
  }

  tags = {
    "Name" = local.name
  }
}

module "additional_sg_matrix_ingress" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.7.0"

  create_security_group = false
  security_group_id     = module.security_group.security_group.id

  matrix_ingress = {
    description = "Matix Ingress rules for PostgreSQL"
    rules = [
      {
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
      },
    ],
    cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
  }

  tags = {
    "Name" = local.name
  }
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
| <a name="module_additional_sg_matrix_ingress"></a> [additional\_sg\_matrix\_ingress](#module\_additional\_sg\_matrix\_ingress) | ../../ | n/a |
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
| <a name="output_terratest"></a> [terratest](#output\_terratest) | The IDs of unknown aws resource to be used by Terratest. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->