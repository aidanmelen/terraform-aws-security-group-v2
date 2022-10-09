# null_unpack_rules sub-module

A sub-module for unpacking security group rule arguments. A single `aws_security_group_rule` resource will result in the EC2 API creating many security group rules when many sources/destinations arguments are specified or a single source/destination argument is specified with many list elements. This will unpacked the list of module rules such that each `aws_security_group_rule` resource results in the EC2 API creating a single security group rule.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Example

```hcl
module "unpack" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"
  rules = [
    {
      from_port                = "443"
      to_port                  = "443"
      protocol                 = "tcp"
      cidr_blocks              = ["10.0.1.0/24", "10.0.2.0/24"]
      ipv6_cidr_blocks         = ["2001:db8::/64"]
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "managed by Terraform"
    }
  ]
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
| <a name="input_rules"></a> [rules](#input\_rules) | The security group rule arguments to unpack. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rules"></a> [rules](#output\_rules) | The unpacked security group rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
