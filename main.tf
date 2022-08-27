###############################################################################
# Security Group
###############################################################################

locals {
  security_group_id  = var.create && var.create_security_group ? aws_security_group.self[0].id : var.security_group_id
  ingress_true_expr  = { for rule in var.ingress : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule }
  egress_true_expr   = { for rule in var.egress : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule }
  ingress_false_expr = { for k, v in local.ingress_true_expr : k => null }
  egress_false_expr  = { for k, v in local.egress_true_expr : k => null } # https://github.com/hashicorp/terraform/issues/28751
}

resource "aws_security_group" "self" {
  count                  = var.create && var.create_security_group ? 1 : 0
  description            = var.description
  egress                 = var.egress
  ingress                = var.ingress
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

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "ingress" {
  for_each                 = var.create ? local.ingress_true_expr : local.ingress_false_expr
  security_group_id        = local.security_group_id
  type                     = "ingress"
  from_port                = try(each.value["from_port"], local.rules[lookup(each.value, "rule")]["from_port"])
  to_port                  = try(each.value["to_port"], local.rules[lookup(each.value, "rule")]["to_port"])
  protocol                 = try(each.value["protocol"], local.rules[lookup(each.value, "rule")]["protocol"])
  cidr_blocks              = try(each.value["cidr_blocks"], local.rules[lookup(each.value, "rule")]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(each.value["ipv6_cidr_blocks"], local.rules[lookup(each.value, "rule")]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(each.value["prefix_list_ids"], local.rules[lookup(each.value, "rule")]["prefix_list_ids"], null)
  self                     = try(each.value["self"], local.rules[lookup(each.value, "rule")]["self"], null)
  source_security_group_id = try(each.value["source_security_group_id"], local.rules[lookup(each.value, "rule")]["source_security_group_id"], null)
  description              = lookup(each.value, "description", "managed by Terraform")
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "egress" {
  for_each                 = var.create ? local.egress_true_expr : local.egress_false_expr
  security_group_id        = local.security_group_id
  type                     = "egress"
  from_port                = try(each.value["from_port"], local.rules[lookup(each.value, "rule")]["from_port"])
  to_port                  = try(each.value["to_port"], local.rules[lookup(each.value, "rule")]["to_port"])
  protocol                 = try(each.value["protocol"], local.rules[lookup(each.value, "rule")]["protocol"])
  cidr_blocks              = try(each.value["cidr_blocks"], local.rules[lookup(each.value, "rule")]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(each.value["ipv6_cidr_blocks"], local.rules[lookup(each.value, "rule")]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(each.value["prefix_list_ids"], local.rules[lookup(each.value, "rule")]["prefix_list_ids"], null)
  self                     = try(each.value["self"], local.rules[lookup(each.value, "rule")]["self"], null)
  source_security_group_id = try(each.value["source_security_group_id"], local.rules[lookup(each.value, "rule")]["source_security_group_id"], null)
  description              = try(lookup(each.value, "description"), local.rules[lookup(each.value, "rule")]["description"], "managed by Terraform")
}

###############################################################################
# Computed Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_ingress" {
  count                    = var.create ? length(var.computed_ingress) : 0
  security_group_id        = local.security_group_id
  type                     = "ingress"
  from_port                = try(var.computed_ingress[count.index]["from_port"], local.rules[lookup(var.computed_ingress[count.index], "rule")]["from_port"])
  to_port                  = try(var.computed_ingress[count.index]["to_port"], local.rules[lookup(var.computed_ingress[count.index], "rule")]["to_port"])
  protocol                 = try(var.computed_ingress[count.index]["protocol"], local.rules[lookup(var.computed_ingress[count.index], "rule")]["protocol"])
  cidr_blocks              = try(var.computed_ingress[count.index]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(var.computed_ingress[count.index]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(var.computed_ingress[count.index]["prefix_list_ids"], null)
  self                     = try(var.computed_ingress[count.index]["self"], null)
  source_security_group_id = try(var.computed_ingress[count.index]["source_security_group_id"], null)
  description              = lookup(var.computed_ingress[count.index], "description", "managed by Terraform")
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_egress" {
  count                    = var.create ? length(var.computed_egress) : 0
  security_group_id        = local.security_group_id
  type                     = "egress"
  from_port                = try(var.computed_egress[count.index]["from_port"], local.rules[lookup(var.computed_egress[count.index], "rule")]["from_port"])
  to_port                  = try(var.computed_egress[count.index]["to_port"], local.rules[lookup(var.computed_egress[count.index], "rule")]["to_port"])
  protocol                 = try(var.computed_egress[count.index]["protocol"], local.rules[lookup(var.computed_egress[count.index], "rule")]["protocol"])
  cidr_blocks              = try(var.computed_egress[count.index]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(var.computed_egress[count.index]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(var.computed_egress[count.index]["prefix_list_ids"], null)
  self                     = try(var.computed_egress[count.index]["self"], null)
  source_security_group_id = try(var.computed_egress[count.index]["source_security_group_id"], null)
  description              = lookup(var.computed_egress[count.index], "description", "managed by Terraform")
}
