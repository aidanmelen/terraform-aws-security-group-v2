locals {
  self_sg_id = var.create_sg ? aws_security_group.self[0].id : var.security_group_id
}

resource "aws_security_group" "self" {
  count                  = var.create_sg ? 1 : 0
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
resource "aws_security_group_rule" "ingress_rules" {
  for_each = var.ingress_rules

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = each.key

  protocol  = each.value["protocol"]
  from_port = each.value["from_port"]
  to_port   = each.value["to_port"]

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

resource "aws_security_group_rule" "egress_rules" {
  for_each = var.egress_rules

  type              = "egress"
  security_group_id = local.self_sg_id
  description       = each.key

  protocol  = each.value["protocol"]
  from_port = each.value["from_port"]
  to_port   = each.value["to_port"]

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

###############################################################################
# Managed Security Group Rules
###############################################################################
resource "aws_security_group_rule" "managed_ingress_rules" {
  for_each = var.managed_ingress_rules

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = each.key

  protocol  = local.managed_rules[each.value["rule"]]["protocol"]
  from_port = local.managed_rules[each.value["rule"]]["from_port"]
  to_port   = local.managed_rules[each.value["rule"]]["to_port"]

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

resource "aws_security_group_rule" "managed_egress_rules" {
  for_each = var.managed_egress_rules

  type              = "egress"
  security_group_id = local.self_sg_id
  description       = each.key

  protocol  = local.managed_rules[each.value["rule"]]["protocol"]
  from_port = local.managed_rules[each.value["rule"]]["from_port"]
  to_port   = local.managed_rules[each.value["rule"]]["to_port"]

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}


