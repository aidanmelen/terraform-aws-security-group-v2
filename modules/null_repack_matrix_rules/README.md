# null_repack_matrix_rules sub-module


A sub-module for repacking security group matrix rule arguments to be the same shape as the `aws_security_group_rule` arguments.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Example

```hcl
module "repack" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"
  matrix = {
    rules = [
      {
        from_port = "443"
        to_port   = "443"
        protocol  = "tcp"
      },
      {
        rule = "http-80-tcp"
      }
    ],
    cidr_blocks              = ["10.0.1.0/24", "10.0.2.0/24"]
    ipv6_cidr_blocks         = ["2001:db8::/64"]
    prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
    source_security_group_id = data.aws_security_group.default.id
    self                     = true
    description              = "managed by Terraform"
  }
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.3 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group rules | `bool` | `true` | no |
| <a name="input_matrix"></a> [matrix](#input\_matrix) | The security group matrix rule arguments to normalize. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rules"></a> [rules](#output\_rules) | The repacked matrix security group rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
