# Rules only with pre-existing security group

Use the module to create rules for a pre-existing security group.

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

## Example

```hcl
resource "aws_security_group" "pre_existing" {
  name        = "${local.name}-pre-existing"
  description = "${local.name}-pre-existing"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-pre-existing"
  }
}

module "sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.4.0"

  create_sg         = false
  security_group_id = aws_security_group.pre_existing.id

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

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region. | `string` | `"us-west-2"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the security group. |
| <a name="output_egress"></a> [egress](#output\_egress) | The security group egress rules. |
| <a name="output_egress_keys"></a> [egress\_keys](#output\_egress\_keys) | The security group egress rules keys. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the security group. |
| <a name="output_ingress"></a> [ingress](#output\_ingress) | The security group ingress rules. |
| <a name="output_ingress_keys"></a> [ingress\_keys](#output\_ingress\_keys) | The security group ingress rules keys. |
| <a name="output_terratest"></a> [terratest](#output\_terratest) | The IDs of uknown aws resource to be used by Terratest. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
