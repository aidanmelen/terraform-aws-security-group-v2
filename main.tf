###############################################################################
# Security Group
###############################################################################

resource "aws_security_group" "self" {
  count                  = var.create && var.create_sg ? 1 : 0
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
# Custom Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "rules" {
  for_each = var.create ? local.rules : local.rules_with_null_values

  type              = split("-", each.key)[0]
  security_group_id = local.self_sg_id
  description       = lookup(each.value, "description", each.key)

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

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "managed_rules" {
  for_each = var.create ? local.managed_rules : local.managed_rules_with_null_values

  type              = split("-", each.key)[0]
  security_group_id = local.self_sg_id
  description       = lookup(each.value, "description", each.key)

  protocol  = local.managed_rule_definitions[each.value["rule"]]["protocol"]
  from_port = local.managed_rule_definitions[each.value["rule"]]["from_port"]
  to_port   = local.managed_rule_definitions[each.value["rule"]]["to_port"]

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}
