###############################################################################
# Computed Custom Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_ingress_rules" {
  count = var.create ? length(var.computed_ingress_rules) : 0

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_ingress_rules[count.index], "description", null)

  from_port = var.computed_ingress_rules[count.index]["from_port"]
  to_port   = var.computed_ingress_rules[count.index]["to_port"]
  protocol  = var.computed_ingress_rules[count.index]["protocol"]

  cidr_blocks              = lookup(var.computed_ingress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_ingress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_ingress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_ingress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_ingress_rules[count.index], "source_security_group_id", null)
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_egress_rules" {
  count = var.create ? length(var.computed_egress_rules) : 0

  type              = "egress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_egress_rules[count.index], "description", null)

  from_port = var.computed_egress_rules[count.index]["from_port"]
  to_port   = var.computed_egress_rules[count.index]["to_port"]
  protocol  = var.computed_egress_rules[count.index]["protocol"]

  cidr_blocks              = lookup(var.computed_egress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_egress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_egress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_egress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_egress_rules[count.index], "source_security_group_id", null)
}

###############################################################################
# Computed Managed Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_managed_ingress_rules" {
  count = var.create ? length(var.computed_managed_ingress_rules) : 0

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_managed_ingress_rules[count.index], "description", var.computed_managed_ingress_rules[count.index]["rule"])

  from_port = local.managed_rule_definitions[var.computed_managed_ingress_rules[count.index]["rule"]]["from_port"]
  to_port   = local.managed_rule_definitions[var.computed_managed_ingress_rules[count.index]["rule"]]["to_port"]
  protocol  = local.managed_rule_definitions[var.computed_managed_ingress_rules[count.index]["rule"]]["protocol"]

  cidr_blocks              = lookup(var.computed_managed_ingress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_managed_ingress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_managed_ingress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_managed_ingress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_managed_ingress_rules[count.index], "source_security_group_id", null)
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_managed_egress_rules" {
  count = var.create ? length(var.computed_managed_egress_rules) : 0

  type              = "egress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_managed_egress_rules[count.index], "description", var.computed_managed_egress_rules[count.index]["rule"])

  from_port = local.managed_rule_definitions[var.computed_managed_egress_rules[count.index]["rule"]]["from_port"]
  to_port   = local.managed_rule_definitions[var.computed_managed_egress_rules[count.index]["rule"]]["to_port"]
  protocol  = local.managed_rule_definitions[var.computed_managed_egress_rules[count.index]["rule"]]["protocol"]

  cidr_blocks              = lookup(var.computed_managed_egress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_managed_egress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_managed_egress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_managed_egress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_managed_egress_rules[count.index], "source_security_group_id", null)
}
