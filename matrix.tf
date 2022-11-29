###############################################################################
# Security Group Matrix Rules
###############################################################################

# repack matrix security group rule arguments
module "matrix_ingress_repack" {
  source = "./modules/null_repack_matrix_rules"
  create = var.create
  matrix = var.matrix_ingress
}

module "matrix_egress_repack" {
  source = "./modules/null_repack_matrix_rules"
  create = var.create
  matrix = var.matrix_egress
}

# normalize managed and common rules
locals {
  matrix_ingress_normalize = [
    for rule in module.matrix_ingress_repack.rules : {
      description = try(
        rule.description,
        var.matrix_ingress.description,
        local.rule_aliases[rule.rule].description,
        var.default_rule_description
      )
      from_port                 = try(rule.from_port, local.managed_rule_aliases[rule.rule].from_port, "The rule alias is invalid: ${rule.rule}. https://github.com/aidanmelen/terraform-aws-security-group-v2#rule-aliases")
      to_port                   = try(rule.to_port, local.managed_rule_aliases[rule.rule].to_port)
      protocol                  = try(rule.protocol, local.managed_rule_aliases[rule.rule].protocol)
      cidr_blocks               = try(rule.cidr_blocks, local.managed_rule_aliases[rule.rule].cidr_blocks, null)
      ipv6_cidr_blocks          = try(rule.ipv6_cidr_blocks, local.managed_rule_aliases[rule.rule].ipv6_cidr_blocks, null)
      prefix_list_ids           = try(rule.prefix_list_ids, local.managed_rule_aliases[rule.rule].prefix_list_ids, null)
      self                      = try(rule.self, local.managed_rule_aliases[rule.rule].self, null)
      source_security_group_id  = try(rule.source_security_group_id, local.managed_rule_aliases[rule.rule].source_security_group_id, null)
      source_security_group_ids = try(rule.source_security_group_ids, local.managed_rule_aliases[rule.rule].source_security_group_ids, null)
    }
    if var.create
  ]

  matrix_egress_normalize = [
    for rule in module.matrix_egress_repack.rules : {
      description = try(
        rule.description,
        var.matrix_egress.description,
        local.managed_rule_aliases[rule.rule].description,
        var.default_rule_description
      )
      from_port                 = try(rule.from_port, local.managed_rule_aliases[rule.rule].from_port, "The rule alias is invalid: ${rule.rule}. https://github.com/aidanmelen/terraform-aws-security-group-v2#rule-aliases")
      to_port                   = try(rule.to_port, local.managed_rule_aliases[rule.rule].to_port)
      protocol                  = try(rule.protocol, local.managed_rule_aliases[rule.rule].protocol)
      cidr_blocks               = try(rule.cidr_blocks, local.managed_rule_aliases[rule.rule].cidr_blocks, null)
      ipv6_cidr_blocks          = try(rule.ipv6_cidr_blocks, local.managed_rule_aliases[rule.rule].ipv6_cidr_blocks, null)
      prefix_list_ids           = try(rule.prefix_list_ids, local.managed_rule_aliases[rule.rule].prefix_list_ids, null)
      self                      = try(rule.self, local.managed_rule_aliases[rule.rule].self, null)
      source_security_group_id  = try(rule.source_security_group_id, local.managed_rule_aliases[rule.rule].source_security_group_id, null)
      source_security_group_ids = try(rule.source_security_group_ids, local.managed_rule_aliases[rule.rule].source_security_group_ids, null)
    }
    if var.create
  ]
}

# unpack security group rule arguments
module "matrix_ingress_unpack" {
  source = "./modules/null_unpack_rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.matrix_ingress_normalize
}

module "matrix_egress_unpack" {
  source = "./modules/null_unpack_rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.matrix_egress_normalize
}

# create map of rules with unique keys to prevent for_each churn that occurs with a set of rules
locals {
  matrix_ingress_map = {
    for rule in try(module.matrix_ingress_unpack[0].rules, local.matrix_ingress_normalize) : lower(join("-", compact([
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

  matrix_egress_map = {
    for rule in try(module.matrix_egress_unpack[0].rules, local.matrix_egress_normalize) : lower(join("-", compact([
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

resource "aws_security_group_rule" "matrix_ingress" {
  for_each                 = local.matrix_ingress_map
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

resource "aws_security_group_rule" "matrix_egress" {
  for_each                 = local.matrix_egress_map
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
