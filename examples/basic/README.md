# Basic Security Group example

Create a basic security group with restrictive ingress HTTPS from 10.0.0.0/24, `all-all` from self, and `all-all` from the WWW.

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
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [
    {
      rule        = "https-443-tcp"
      description = "My Service."
      cidr_blocks = ["10.0.0.0/24"]
    },
    {
      rule = "all-all"
      self = true
    }
  ]

  managed_egress_rules = [
    {
      rule        = "all-all"
      cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
    },
    {
      rule             = "all-all"
      ipv6_cidr_blocks = ["::/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
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
| <a name="output_egress_rule_keys"></a> [egress\_rule\_keys](#output\_egress\_rule\_keys) | The egress security group rule keys. |
| <a name="output_ingress_rule_keys"></a> [ingress\_rule\_keys](#output\_ingress\_rule\_keys) | The ingress security group rule keys. |
| <a name="output_managed_egress_rule_keys"></a> [managed\_egress\_rule\_keys](#output\_managed\_egress\_rule\_keys) | The managed egress security group rule keys. |
| <a name="output_managed_ingress_rule_keys"></a> [managed\_ingress\_rule\_keys](#output\_managed\_ingress\_rule\_keys) | The managed ingress security group rule keys. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
