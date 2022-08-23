# Complete Security Group example

Configuration in this directory creates set of Security Group and Security Group Rules resources in various combinations.

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
| <a name="output_egress_rule_keys"></a> [egress\_rule\_keys](#output\_egress\_rule\_keys) | The egress security group rule keys. |
| <a name="output_ingress_rule_keys"></a> [ingress\_rule\_keys](#output\_ingress\_rule\_keys) | The ingress security group rule keys. |
| <a name="output_managed_egress_rule_keys"></a> [managed\_egress\_rule\_keys](#output\_managed\_egress\_rule\_keys) | The managed egress security group rule keys. |
| <a name="output_managed_ingress_rule_keys"></a> [managed\_ingress\_rule\_keys](#output\_managed\_ingress\_rule\_keys) | The managed ingress security group rule keys. |
| <a name="output_pre_existing_sg_id"></a> [pre\_existing\_sg\_id](#output\_pre\_existing\_sg\_id) | The pre-existing security group ID. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
