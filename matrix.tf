###############################################################################
# Computed Security Group Ingress Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_matrix_ingress_with_cidr_blocks_and_prefix_list_ids" {
  count                    = try(length(var.computed_matrix_ingress["rules"]), 0)
  security_group_id        = local.security_group_id
  type                     = "ingress"
  from_port                = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["from_port"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["from_port"])
  to_port                  = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["to_port"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["to_port"])
  protocol                 = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["protocol"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["protocol"])
  cidr_blocks              = var.computed_matrix_ingress.cidr_blocks
  ipv6_cidr_blocks         = var.computed_matrix_ingress.ipv6_cidr_blocks
  prefix_list_ids          = var.computed_matrix_ingress.prefix_list_ids
  source_security_group_id = null
  self                     = null
  description              = null
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_matrix_ingress_with_source_security_group_ids" {
  count                    = try(length(var.computed_matrix_ingress.source_security_group_ids) * length(var.computed_matrix_ingress["rules"]), 0)
  security_group_id        = local.security_group_id
  type                     = "ingress"
  from_port                = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["from_port"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["from_port"])
  to_port                  = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["to_port"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["to_port"])
  protocol                 = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["protocol"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["protocol"])
  cidr_blocks              = null
  ipv6_cidr_blocks         = null
  prefix_list_ids          = null
  source_security_group_id = var.computed_matrix_ingress.source_security_group_ids[count.index % length(var.computed_matrix_ingress["rules"])]
  self                     = null
  description              = null
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_matrix_ingress_with_self" {
  count                    = try(var.computed_matrix_ingress.self ? length(var.computed_matrix_ingress["rules"]) : 0, 0)
  security_group_id        = local.security_group_id
  type                     = "ingress"
  from_port                = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["from_port"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["from_port"])
  to_port                  = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["to_port"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["to_port"])
  protocol                 = try(local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["rule"]]["protocol"], var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress["rules"])]["protocol"])
  cidr_blocks              = null
  ipv6_cidr_blocks         = null
  prefix_list_ids          = null
  source_security_group_id = null
  self                     = true
  description              = null
}

###############################################################################
# Computed Security Group Egress Rules
###############################################################################
