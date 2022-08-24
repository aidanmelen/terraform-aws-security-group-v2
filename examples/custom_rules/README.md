# Security Group with Custom Rules Example

Create a security group with custom rules.

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
| <a name="output_auto_group_egress_all_to_public_internet_rule_keys"></a> [auto\_group\_egress\_all\_to\_public\_internet\_rule\_keys](#output\_auto\_group\_egress\_all\_to\_public\_internet\_rule\_keys) | The auto group egress all to public internet rule keys. |
| <a name="output_auto_group_ingress_all_from_self_rule_keys"></a> [auto\_group\_ingress\_all\_from\_self\_rule\_keys](#output\_auto\_group\_ingress\_all\_from\_self\_rule\_keys) | The auto group ingress all to self rule key. |
| <a name="output_auto_group_ingress_http_from_public_internet_rule_keys"></a> [auto\_group\_ingress\_http\_from\_public\_internet\_rule\_keys](#output\_auto\_group\_ingress\_http\_from\_public\_internet\_rule\_keys) | The auto group ingress HTTP from the public internet rule keys. |
| <a name="output_auto_group_ingress_https_from_public_internet_rule_keys"></a> [auto\_group\_ingress\_https\_from\_public\_internet\_rule\_keys](#output\_auto\_group\_ingress\_https\_from\_public\_internet\_rule\_keys) | The auto group ingress HTTPS from the public internet rule keys. |
| <a name="output_computed_egress_rule_ids"></a> [computed\_egress\_rule\_ids](#output\_computed\_egress\_rule\_ids) | The computed egress security group rule IDs. |
| <a name="output_computed_ingress_rule_ids"></a> [computed\_ingress\_rule\_ids](#output\_computed\_ingress\_rule\_ids) | The computed ingress security group rule IDs. |
| <a name="output_computed_managed_egress_rule_ids"></a> [computed\_managed\_egress\_rule\_ids](#output\_computed\_managed\_egress\_rule\_ids) | The computed managed egress security group rule IDs. |
| <a name="output_computed_managed_ingress_rule_ids"></a> [computed\_managed\_ingress\_rule\_ids](#output\_computed\_managed\_ingress\_rule\_ids) | The computed managed ingress security group rule IDs. |
| <a name="output_egress_rule_keys"></a> [egress\_rule\_keys](#output\_egress\_rule\_keys) | The egress security group rule keys. |
| <a name="output_ingress_rule_keys"></a> [ingress\_rule\_keys](#output\_ingress\_rule\_keys) | The ingress security group rule keys. |
| <a name="output_managed_egress_rule_keys"></a> [managed\_egress\_rule\_keys](#output\_managed\_egress\_rule\_keys) | The managed egress security group rule keys. |
| <a name="output_managed_ingress_rule_keys"></a> [managed\_ingress\_rule\_keys](#output\_managed\_ingress\_rule\_keys) | The managed ingress security group rule keys. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
