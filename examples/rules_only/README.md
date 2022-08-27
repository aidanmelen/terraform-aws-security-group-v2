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

module "security_group" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 0.5.1"

  create_security_group = false
  security_group_id     = aws_security_group.pre_existing.id

  ingress = [{ rule = "https-from-public" }]
  egress  = [{ rule = "all-to-public" }]

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
| <a name="output_security_group"></a> [security\_group](#output\_security\_group) | The security group. |
| <a name="output_terratest"></a> [terratest](#output\_terratest) | The IDs of uknown aws resource to be used by Terratest. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
