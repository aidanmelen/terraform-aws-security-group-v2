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
  # list of objects for grouped rules
  ingress = {
    for rule in var.ingress : lower(join("-", compact([
      "ingress",
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.source_security_group_id, null),
      try(rule.self, null),
    ]))) => rule if var.create && !var.expand
  }

  egress = {
    for rule in var.egress : lower(join("-", compact([
      "egress",
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.source_security_group_id, null),
      try(rule.self, null),
    ]))) => rule if var.create && !var.expand
  }
}

module "expand_ingress" {
  source = "./modules/null-expand-aws-security-group-rules"
  count  = var.expand ? 1 : 0
  create = var.create
  rules = [
    for i in try(var.ingress, []) : {
      type                     = "ingress"
      rule                     = try(i.rule, null)
      from_port                = try(i.from_port, null)
      to_port                  = try(i.to_port, null)
      protocol                 = try(i.protocol, null)
      cidr_blocks              = try(i.cidr_blocks, null)
      ipv6_cidr_blocks         = try(i.ipv6_cidr_blocks, null)
      prefix_list_ids          = try(i.prefix_list_ids, null)
      source_security_group_id = try(i.source_security_group_id, null)
      self                     = try(i.self, null)
      description              = try(i.description, null)
    }
  ]
}

module "expand_egress" {
  source = "./modules/null-expand-aws-security-group-rules"
  count  = var.expand ? 1 : 0
  create = var.create
  rules = [
    for e in try(var.egress, []) : {
      type                     = "ingress"
      rule                     = try(e.rule, null)
      from_port                = try(e.from_port, null)
      to_port                  = try(e.to_port, null)
      protocol                 = try(e.protocol, null)
      cidr_blocks              = try(e.cidr_blocks, null)
      ipv6_cidr_blocks         = try(e.ipv6_cidr_blocks, null)
      prefix_list_ids          = try(e.prefix_list_ids, null)
      source_security_group_id = try(e.source_security_group_id, null)
      self                     = try(e.self, null)
      description              = try(e.description, null)
    }
  ]
}

resource "aws_security_group_rule" "ingress" {
  for_each                 = try(module.expand_ingress.rules[0], local.ingress)
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
  for_each                 = try(module.expand_egress.rules[0], local.egress)
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
