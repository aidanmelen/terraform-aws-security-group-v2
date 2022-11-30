# Security Group rule with source_security_group_ids

This module supports a list of `source_security_group_ids` when `unpack = true`. This is a workaround for [26642](https://github.com/hashicorp/terraform-provider-aws/issues/26642).

## Limitations

`source_security_group_ids` is only supported with `ingress`, `egress`, `matrix_ingress`, and `matrix_egress` module rules.

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
  version = ">= 2.1.0"

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  # unpack is required when using a list of source_security_group_ids
  # because the aws_security_group_rule resource only supports source_security_group_id
  unpack = true

  ingress = [
    {
      rule                      = "https-443-tcp"
      source_security_group_ids = [data.aws_security_group.default.id]
    }
  ]
}

module "security_group_matrix" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 2.1.0"

  name   = "${local.name}-matrix"
  vpc_id = data.aws_vpc.default.id

  unpack = true

  matrix_ingress = {
    rules                     = [{ rule = "https-443-tcp" }]
    source_security_group_ids = [data.aws_security_group.default.id]
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
| <a name="module_security_group"></a> [security\_group](#module\_security\_group) | ../../ | n/a |
| <a name="module_security_group_matrix"></a> [security\_group\_matrix](#module\_security\_group\_matrix) | ../../ | n/a |
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
| <a name="output_terratest"></a> [terratest](#output\_terratest) | Outputs used by Terratest. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
