# null_repack_matrix_rules sub-module


A sub-module for repacking security group matrix rule. Each matrix rule (`rule` or `from_port`, `to_port`, and `protocol`) will be repacked using three `aws_security_groups_rule` resources. The first resource will pack rules with `cidr_blocks`, `ipv6_cidr_blocks`, and `prefix_list_ids`. The second resource will pack rules with `source_security_group_id`. Finally, the third resource will pack the rules with `self`. As a result, all matrix rules are optimally packed without incompatible sources/destinations.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Example

```hcl
module "repack" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 2.0.1"
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

# Outputs:

# rules = [
#   {
#     "cidr_blocks" = [
#       "10.0.1.0/24",
#       "10.0.2.0/24",
#     ]
#     "from_port" = "443"
#     "ipv6_cidr_blocks" = [
#       "2001:db8::/64",
#     ]
#     "prefix_list_ids" = [
#       "pl-11111111",
#     ]
#     "protocol" = "tcp"
#     "to_port" = "443"
#   },
#   {
#     "cidr_blocks" = [
#       "10.0.1.0/24",
#       "10.0.2.0/24",
#     ]
#     "ipv6_cidr_blocks" = [
#       "2001:db8::/64",
#     ]
#     "prefix_list_ids" = [
#       "pl-11111111",
#     ]
#     "rule" = "http-80-tcp"
#   },
#   {
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "source_security_group_id" = "sg-11111111"
#     "to_port" = "443"
#   },
#   {
#     "rule" = "http-80-tcp"
#     "source_security_group_id" = "sg-11111111"
#   },
#   {
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "self" = true
#     "to_port" = "443"
#   },
#   {
#     "rule" = "http-80-tcp"
#     "self" = true
#   },
# ]
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
