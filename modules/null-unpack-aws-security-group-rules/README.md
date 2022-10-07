# null-unpack-aws-security-group-rules

A sub-module for unpacking security group rule argument groups. A single `aws_security_group_rule` resource will result in the EC2 API creating many security group rules when many sources/destinations arguments are specified or a single source/destination argument is specified with many list elements. This will unpacked the list of module rules such that each `aws_security_group_rule` resource results in the EC2 API creating a single security group rule.

## Example

```hcl
###############################################################################
# Security Group Rules
###############################################################################

# normalize customer, managed and common rules
locals {
  ingress_normalized = [
    for rule in var.ingress : {
      description              = try(rule.description, local.rule_aliases[rule.rule].description, var.default_rule_description)
      from_port                = try(rule.from_port, local.rule_aliases[rule.rule].from_port)
      to_port                  = try(rule.to_port, local.rule_aliases[rule.rule].to_port)
      protocol                 = try(rule.protocol, local.rule_aliases[rule.rule].protocol)
      cidr_blocks              = try(rule.cidr_blocks, local.rule_aliases[rule.rule].cidr_blocks, null)
      ipv6_cidr_blocks         = try(rule.ipv6_cidr_blocks, local.rule_aliases[rule.rule].ipv6_cidr_blocks, null)
      prefix_list_ids          = try(rule.prefix_list_ids, local.rule_aliases[rule.rule].prefix_list_ids, null)
      self                     = try(rule.self, local.rule_aliases[rule.rule].self, null)
      source_security_group_id = try(rule.source_security_group_id, local.rule_aliases[rule.rule].source_security_group_id, null)
    }
    if var.create
  ]

  egress_normalized = [
    for rule in var.egress : {
      description              = try(rule.description, local.rule_aliases[rule.rule].description, var.default_rule_description)
      from_port                = try(rule.from_port, local.rule_aliases[rule.rule].from_port)
      to_port                  = try(rule.to_port, local.rule_aliases[rule.rule].to_port)
      protocol                 = try(rule.protocol, local.rule_aliases[rule.rule].protocol)
      cidr_blocks              = try(rule.cidr_blocks, local.rule_aliases[rule.rule].cidr_blocks, null)
      ipv6_cidr_blocks         = try(rule.ipv6_cidr_blocks, local.rule_aliases[rule.rule].ipv6_cidr_blocks, null)
      prefix_list_ids          = try(rule.prefix_list_ids, local.rule_aliases[rule.rule].prefix_list_ids, null)
      self                     = try(rule.self, local.rule_aliases[rule.rule].self, null)
      source_security_group_id = try(rule.source_security_group_id, local.rule_aliases[rule.rule].source_security_group_id, null)
    }
    if var.create
  ]
}

# unpack security group rules with grouped arguments
module "ingress_unpacked" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.ingress_normalized
}

module "egress_unpacked" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.egress_normalized
}

# create map of rules with unique keys to prevent for_each churn that occurs with a set of rules
locals {
  ingress_map = {
    for rule in try(module.ingress_unpacked[0].rules, local.ingress_normalized) : lower(join("-", compact([
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.self, null),
      try(rule.source_security_group_id, null),
    ]))) => rule
  }

  egress_map = {
    for rule in try(module.egress_unpacked[0].rules, local.egress_normalized) : lower(join("-", compact([
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.self, null),
      try(rule.source_security_group_id, null),
    ]))) => rule
  }
}

resource "aws_security_group_rule" "ingress" {
  for_each                 = local.ingress_map
  security_group_id        = local.security_group_id
  type                     = "ingress"
  description              = try(each.value.description, null)
  from_port                = try(each.value.from_port, null)
  to_port                  = try(each.value.to_port, null)
  protocol                 = try(each.value.protocol, null)
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}

resource "aws_security_group_rule" "egress" {
  for_each                 = local.egress_map
  security_group_id        = local.security_group_id
  type                     = "egress"
  description              = try(each.value.description, null)
  from_port                = try(each.value.from_port, null)
  to_port                  = try(each.value.to_port, null)
  protocol                 = try(each.value.protocol, null)
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}
```
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Whether to create security group rules | `bool` | `true` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | The grouped security rules to unpack into dedicated security group rules. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rules"></a> [rules](#output\_rules) | The unpacked security group rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

Apache 2 Licensed. See [LICENSE](https://github.com/aidanmelen/terraform-kubernetes-confluent-platform/blob/main/LICENSE) for full details.
