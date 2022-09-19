locals {
  security_group_id = var.create && var.create_security_group ? aws_security_group.self[0].id : var.security_group_id
  ingress_true_expr = { for rule in var.ingress : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule }
  egress_true_expr  = { for rule in var.egress : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule }

  # https://github.com/hashicorp/terraform/issues/28751
  ingress_false_expr = { for k, rule in local.ingress_true_expr : k => null }
  egress_false_expr  = { for k, rule in local.egress_true_expr : k => null }
}

###############################################################################
# Security Group
###############################################################################

resource "aws_security_group" "self" {
  count                  = var.create && var.create_security_group ? 1 : 0
  description            = var.description
  name_prefix            = var.name_prefix
  name                   = var.name
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = var.tags
  vpc_id                 = var.vpc_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

###############################################################################
# Security Group Rules
###############################################################################

resource "aws_security_group_rule" "ingress" {
  for_each                 = var.create ? local.ingress_true_expr : local.ingress_false_expr
  security_group_id        = local.security_group_id
  type                     = try(each.value["type"], local.rules[each.value["rule"]]["type"], "ingress")
  description              = try(each.value["description"], local.rules[each.value["rule"]]["description"], var.default_rule_description)
  from_port                = try(each.value["from_port"], local.rules[each.value["rule"]]["from_port"])
  to_port                  = try(each.value["to_port"], local.rules[each.value["rule"]]["to_port"])
  protocol                 = try(each.value["protocol"], local.rules[each.value["rule"]]["protocol"])
  cidr_blocks              = try(each.value["cidr_blocks"], local.rules[each.value["rule"]]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(each.value["ipv6_cidr_blocks"], local.rules[each.value["rule"]]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(each.value["prefix_list_ids"], local.rules[each.value["rule"]]["prefix_list_ids"], null)
  self                     = try(each.value["self"], local.rules[each.value["rule"]]["self"], null)
  source_security_group_id = try(each.value["source_security_group_id"], local.rules[each.value["rule"]]["source_security_group_id"], null)
}

resource "aws_security_group_rule" "egress" {
  for_each                 = var.create ? local.egress_true_expr : local.egress_false_expr
  security_group_id        = local.security_group_id
  type                     = try(each.value["type"], local.rules[each.value["rule"]]["type"], "egress")
  description              = try(each.value["description"], local.rules[each.value["rule"]]["description"], var.default_rule_description)
  from_port                = try(each.value["from_port"], local.rules[each.value["rule"]]["from_port"])
  to_port                  = try(each.value["to_port"], local.rules[each.value["rule"]]["to_port"])
  protocol                 = try(each.value["protocol"], local.rules[each.value["rule"]]["protocol"])
  cidr_blocks              = try(each.value["cidr_blocks"], local.rules[each.value["rule"]]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(each.value["ipv6_cidr_blocks"], local.rules[each.value["rule"]]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(each.value["prefix_list_ids"], local.rules[each.value["rule"]]["prefix_list_ids"], null)
  self                     = try(each.value["self"], local.rules[each.value["rule"]]["self"], null)
  source_security_group_id = try(each.value["source_security_group_id"], local.rules[each.value["rule"]]["source_security_group_id"], null)
}
