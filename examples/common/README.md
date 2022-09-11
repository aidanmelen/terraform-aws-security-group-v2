# Security Group with customer rules

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
module "public_https_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.7.0"

  name        = "${local.name}-https"
  description = "${local.name}-https"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "https-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]

  tags = {
    "Name" = "${local.name}-https"
  }
}

module "public_http_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.7.0"

  name        = "${local.name}-http"
  description = "${local.name}-http"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "http-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]

  tags = {
    "Name" = "${local.name}-http"
  }
}

module "ssh_sg" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.7.0"

  name        = "${local.name}-ssh"
  description = "${local.name}-ssh"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "ssh-tcp", cidr_blocks = ["10.0.0.0/24"] }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]

  tags = {
    "Name" = "${local.name}-ssh"
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
| <a name="module_ssh_sg"></a> [ssh\_sg](#module\_ssh\_sg) | ../../ | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region. | `string` | `"us-west-2"` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_http_sg_egress_keys"></a> [public\_http\_sg\_egress\_keys](#output\_public\_http\_sg\_egress\_keys) | The public HTTP security group egress rules keys. |
| <a name="output_public_http_sg_id"></a> [public\_http\_sg\_id](#output\_public\_http\_sg\_id) | The ID of the public HTTP security group. |
| <a name="output_public_http_sg_ingress_keys"></a> [public\_http\_sg\_ingress\_keys](#output\_public\_http\_sg\_ingress\_keys) | The public HTTP security group ingress rules keys. |
| <a name="output_public_https_sg_egress_keys"></a> [public\_https\_sg\_egress\_keys](#output\_public\_https\_sg\_egress\_keys) | The public HTTPS security group egress rules keys. |
| <a name="output_public_https_sg_id"></a> [public\_https\_sg\_id](#output\_public\_https\_sg\_id) | The ID of the public HTTPS security group. |
| <a name="output_public_https_sg_ingress_keys"></a> [public\_https\_sg\_ingress\_keys](#output\_public\_https\_sg\_ingress\_keys) | The public HTTPS security group ingress rules keys. |
| <a name="output_ssh_sg_egress_keys"></a> [ssh\_sg\_egress\_keys](#output\_ssh\_sg\_egress\_keys) | The SSH security group egress rules keys. |
| <a name="output_ssh_sg_id"></a> [ssh\_sg\_id](#output\_ssh\_sg\_id) | The ID of the public SSH security group. |
| <a name="output_ssh_sg_ingress_keys"></a> [ssh\_sg\_ingress\_keys](#output\_ssh\_sg\_ingress\_keys) | The SSH security group ingress rules keys. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
