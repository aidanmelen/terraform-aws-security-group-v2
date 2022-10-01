# expand

A single `aws_security_group_rule` resource will result in the EC2 API creating many security group rules when declared with many source(s)/destination(s) (e.g., cidr_block) or a single source/destination with many list elements.
This module ensures that the module rule arguments are expanded such that each `aws_security_group_rule` resource results in the EC2 API creating a single security group rule.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group rules | `bool` | `true` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | The grouped security rules to expand into dedicated security group rules. | `list(any)` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rules"></a> [rules](#output\_rules) | The expanded security group rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
