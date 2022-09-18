# Security Group with common rules

Create security group with common scenario rules (e.g. `https-tcp-from-public`, `all-all-from-self`, `all-all-to-public`, etc). This is like a shortcut for managed rules that have a known source or destination.



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
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "public_https_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.1.0"

  name        = "${local.name}-https"
  description = "${local.name}-https"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "https-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]

  tags = {
    "Name" = "${local.name}-https"
  }
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "public_http_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.1.0"

  name        = "${local.name}-http"
  description = "${local.name}-http"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "http-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]

  tags = {
    "Name" = "${local.name}-http"
  }
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "rule_type_override_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.1.0"

  name        = "${local.name}-rule-type-override"
  description = "${local.name}-rule-type-override"
  vpc_id      = data.aws_vpc.default.id

  # override the default type for the ingress module arguments
  ingress = [
    {
      # managed type (egress) for the common rule will take precedence over the module argument (ingress)
      rule = "all-all-to-public",
    },
    {
      # the type argument (egress) will take precedence over both the module argument and common rule type (ingress)
      rule = "all-all-from-self"
      type = "egress"
    }
  ]

  # egress rules will be created using the rules from above eventhough the egress module argument is empty
  egress = []

  tags = {
    "Name" = "${local.name}-rule-type-override"
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
| <a name="module_public_http_sg"></a> [public\_http\_sg](#module\_public\_http\_sg) | ../../ | n/a |
| <a name="module_public_https_sg"></a> [public\_https\_sg](#module\_public\_https\_sg) | ../../ | n/a |
| <a name="module_rule_type_override_sg"></a> [rule\_type\_override\_sg](#module\_rule\_type\_override\_sg) | ../../ | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region. | `string` | `"us-west-2"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_http_egress"></a> [public\_http\_egress](#output\_public\_http\_egress) | The public HTTP security group egress rules. |
| <a name="output_public_http_ingress"></a> [public\_http\_ingress](#output\_public\_http\_ingress) | The public HTTP security group ingress rules. |
| <a name="output_public_http_sg_id"></a> [public\_http\_sg\_id](#output\_public\_http\_sg\_id) | The ID of the public HTTP security group. |
| <a name="output_public_https_egress"></a> [public\_https\_egress](#output\_public\_https\_egress) | The public HTTPS security group egress rules. |
| <a name="output_public_https_ingress"></a> [public\_https\_ingress](#output\_public\_https\_ingress) | The public HTTPS security group ingress rules. |
| <a name="output_public_https_sg_id"></a> [public\_https\_sg\_id](#output\_public\_https\_sg\_id) | The ID of the public HTTPS security group. |
| <a name="output_rule_type_override_egress"></a> [rule\_type\_override\_egress](#output\_rule\_type\_override\_egress) | The rule type override security group egress rules. |
| <a name="output_rule_type_override_ingress"></a> [rule\_type\_override\_ingress](#output\_rule\_type\_override\_ingress) | The rule type override security group ingress rules. |
| <a name="output_rule_type_override_sg_id"></a> [rule\_type\_override\_sg\_id](#output\_rule\_type\_override\_sg\_id) | The ID of the rule type override security group. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
