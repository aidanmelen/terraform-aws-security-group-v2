# Computed Security Group example

Create a security group with a computed rules. Computed security group rules uses `count` to dynamically create rules with unknown values during the initial Terraform plan. Please see [Limitations on values used in for_each](https://www.terraform.io/language/meta-arguments/for_each#limitations-on-values-used-in-for_each).

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
###############################################################################
# Resources That Must Use Computed Security Group Rules
###############################################################################

resource "aws_security_group" "other" {
  name        = "${local.name}-other"
  description = "${local.name}-other"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-other"
  }
}

resource "aws_ec2_managed_prefix_list" "other" {
  name           = "${local.name}-other"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = data.aws_vpc.default.cidr_block
    description = "Primary"
  }
}

###############################################################################
# Security Group
###############################################################################

module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.1.0"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

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
| <a name="output_auto_group_egress_all_to_public_internet_rule_keys"></a> [auto\_group\_egress\_all\_to\_public\_internet\_rule\_keys](#output\_auto\_group\_egress\_all\_to\_public\_internet\_rule\_keys) | The auto group egress all to public internet rule keys. |
| <a name="output_auto_group_egress_to_public_internet_rule_ids"></a> [auto\_group\_egress\_to\_public\_internet\_rule\_ids](#output\_auto\_group\_egress\_to\_public\_internet\_rule\_ids) | The auto group egress all to public internet rule IDs. |
| <a name="output_auto_group_ingress_all_from_self_rule_ids"></a> [auto\_group\_ingress\_all\_from\_self\_rule\_ids](#output\_auto\_group\_ingress\_all\_from\_self\_rule\_ids) | The auto group ingress all to self rule IDs. |
| <a name="output_auto_group_ingress_all_from_self_rule_keys"></a> [auto\_group\_ingress\_all\_from\_self\_rule\_keys](#output\_auto\_group\_ingress\_all\_from\_self\_rule\_keys) | The auto group ingress all to self rule keys. |
| <a name="output_computed_egress_rule_ids"></a> [computed\_egress\_rule\_ids](#output\_computed\_egress\_rule\_ids) | The computed egress security group rule IDs. |
| <a name="output_computed_ingress_rule_ids"></a> [computed\_ingress\_rule\_ids](#output\_computed\_ingress\_rule\_ids) | The computed ingress security group rule IDs. |
| <a name="output_computed_managed_egress_rule_ids"></a> [computed\_managed\_egress\_rule\_ids](#output\_computed\_managed\_egress\_rule\_ids) | The computed managed egress security group rule IDs. |
| <a name="output_computed_managed_ingress_rule_ids"></a> [computed\_managed\_ingress\_rule\_ids](#output\_computed\_managed\_ingress\_rule\_ids) | The computed managed ingress security group rule IDs. |
| <a name="output_egress_rule_keys"></a> [egress\_rule\_keys](#output\_egress\_rule\_keys) | The egress security group rule keys. |
| <a name="output_ingress_rule_keys"></a> [ingress\_rule\_keys](#output\_ingress\_rule\_keys) | The ingress security group rule keys. |
| <a name="output_managed_egress_rule_keys"></a> [managed\_egress\_rule\_keys](#output\_managed\_egress\_rule\_keys) | The managed egress security group rule keys. |
| <a name="output_managed_ingress_rule_keys"></a> [managed\_ingress\_rule\_keys](#output\_managed\_ingress\_rule\_keys) | The managed ingress security group rule keys. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
