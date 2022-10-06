###############################################################################
# Security Group
###############################################################################

locals {
  security_group_id = var.create && var.create_security_group ? try(
    aws_security_group.self[0].id,
    aws_security_group.self_with_name_prefix[0].id
  ) : var.security_group_id
}

resource "aws_security_group" "self" {
  count                  = var.create && var.create_security_group && var.name_prefix == null ? 1 : 0
  description            = var.description
  name                   = var.name
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = merge({ "Name" : var.name }, var.tags)
  vpc_id                 = var.vpc_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

resource "aws_security_group" "self_with_name_prefix" {
  count                  = var.create && var.create_security_group && var.name_prefix != null ? 1 : 0
  description            = var.description
  name_prefix            = format("%s%s", var.name_prefix, var.name_prefix_separator)
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = merge({ "Name" : var.name }, var.tags)
  vpc_id                 = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

###############################################################################
# Security Group Rules
###############################################################################

locals {
  ingress = {
    for rule in var.ingress : lower(join("-", compact([
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.self, null),
      try(rule.source_security_group_id, null),
    ]))) => rule if var.create
  }

  egress = {
    for rule in var.egress : lower(join("-", compact([
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.self, null),
      try(rule.source_security_group_id, null),
    ]))) => rule if var.create
  }
}

module "unpack_ingress" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.ingress
}

module "unpack_egress" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.egress
}

resource "aws_security_group_rule" "ingress" {
  for_each                 = try(module.unpack_ingress[0].rules, local.ingress)
  security_group_id        = local.security_group_id
  type                     = "ingress"
  description              = try(each.value.description, local.rules[each.value.rule].description, var.default_rule_description)
  from_port                = try(each.value.from_port, local.rules[each.value.rule].from_port)
  to_port                  = try(each.value.to_port, local.rules[each.value.rule].to_port)
  protocol                 = try(each.value.protocol, local.rules[each.value.rule].protocol)
  cidr_blocks              = try(each.value.cidr_blocks, local.rules[each.value.rule].cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, local.rules[each.value.rule].ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, local.rules[each.value.rule].prefix_list_ids, null)
  self                     = try(each.value.self, local.rules[each.value.rule].self, null)
  source_security_group_id = try(each.value.source_security_group_id, local.rules[each.value.rule].source_security_group_id, null)
}

resource "aws_security_group_rule" "egress" {
  for_each                 = try(module.unpack_egress[0].rules, local.egress)
  security_group_id        = local.security_group_id
  type                     = "egress"
  description              = try(each.value.description, local.rules[each.value.rule].description, var.default_rule_description)
  from_port                = try(each.value.from_port, local.rules[each.value.rule].from_port)
  to_port                  = try(each.value.to_port, local.rules[each.value.rule].to_port)
  protocol                 = try(each.value.protocol, local.rules[each.value.rule].protocol)
  cidr_blocks              = try(each.value.cidr_blocks, local.rules[each.value.rule].cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, local.rules[each.value.rule].ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, local.rules[each.value.rule].prefix_list_ids, null)
  self                     = try(each.value.self, local.rules[each.value.rule].self, null)
  source_security_group_id = try(each.value.source_security_group_id, local.rules[each.value.rule].source_security_group_id, null)
}
