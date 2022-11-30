# Security Group with common rules

Create security group with common scenario rules (e.g. `https-tcp-from-public`, `all-all-from-self`, `all-all-to-public`, etc). This is like a shortcut for managed rules that have a known source or destination.

Some common rules may contain either `to` or `from` for readability. This is purely cosmetic as the rule type is determined by the module arguments.

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
#tfsec:ignore:aws-vpc-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "public_https_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 2.1.0"

  name        = "${local.name}-https"
  description = "${local.name}-https"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "https-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "public_http_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 2.1.0"

  name        = "${local.name}-http"
  description = "${local.name}-http"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "http-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]
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
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
