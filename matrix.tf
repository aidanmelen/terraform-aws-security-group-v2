###############################################################################
# Matrix Security Group Ingress Rules
###############################################################################

###############################################################################
# Matrix Security Group Egress Rules
###############################################################################

###############################################################################
# Matrix Computed Security Group Ingress Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_matrix_ingress_with_cidr_blocks_and_prefix_list_ids" {
  count = anytrue([
    length(lookup(var.computed_matrix_ingress, "cidr_blocks", [])) > 0,
    length(lookup(var.computed_matrix_ingress, "ipv6_cidr_blocks", [])) > 0,
    length(lookup(var.computed_matrix_ingress, "prefix_list_ids", [])) > 0,
  ]) ? length(var.computed_matrix_ingress.rules) : 0
  security_group_id = local.security_group_id
  type              = "ingress"

  # customer, managed or common rules
  from_port = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["from_port"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["to_port"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["protocol"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["protocol"]
  )

  # sources
  cidr_blocks              = try(var.computed_matrix_ingress.cidr_blocks, null)
  ipv6_cidr_blocks         = try(var.computed_matrix_ingress.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(var.computed_matrix_ingress.prefix_list_ids, null)
  source_security_group_id = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
  self                     = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
  description              = null
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_matrix_ingress_with_source_security_group_ids" {
  count             = try(length(var.computed_matrix_ingress.source_security_group_ids) * length(var.computed_matrix_ingress.rules), 0)
  security_group_id = local.security_group_id
  type              = "ingress"

  # customer, managed or common rules
  from_port = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["from_port"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["to_port"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["protocol"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["protocol"]
  )

  # sources
  cidr_blocks              = null # Cannot be specified with source_security_group_id
  ipv6_cidr_blocks         = null # Cannot be specified with source_security_group_id
  prefix_list_ids          = null # Cannot be specified with source_security_group_id
  source_security_group_id = var.computed_matrix_ingress.source_security_group_ids[count.index % length(var.computed_matrix_ingress.rules)]
  self                     = null # Cannot be specified with source_security_group_id
  description              = null
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_matrix_ingress_with_self" {
  count             = try(var.computed_matrix_ingress.self ? length(var.computed_matrix_ingress.rules) : 0, 0)
  security_group_id = local.security_group_id
  type              = "ingress"

  # customer, managed or common rules
  from_port = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["from_port"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["to_port"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["rule"]]["protocol"],
    var.computed_matrix_ingress.rules[count.index % length(var.computed_matrix_ingress.rules)]["protocol"]
  )

  # sources
  cidr_blocks              = null # Cannot be specified with self
  ipv6_cidr_blocks         = null # Cannot be specified with self
  prefix_list_ids          = null # Cannot be specified with self
  source_security_group_id = null # Cannot be specified with self
  self                     = true
  description              = null
}

###############################################################################
# Matrix Computed Security Group Egress Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_matrix_egress_with_cidr_blocks_and_prefix_list_ids" {
  count = anytrue([
    length(lookup(var.computed_matrix_egress, "cidr_blocks", [])) > 0,
    length(lookup(var.computed_matrix_egress, "ipv6_cidr_blocks", [])) > 0,
    length(lookup(var.computed_matrix_egress, "prefix_list_ids", [])) > 0,
  ]) ? length(var.computed_matrix_egress.rules) : 0
  security_group_id = local.security_group_id
  type              = "egress"

  # customer, managed or common rules
  from_port = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["from_port"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["to_port"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["protocol"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["protocol"]
  )

  # destinations
  cidr_blocks              = try(var.computed_matrix_egress.cidr_blocks, null)
  ipv6_cidr_blocks         = try(var.computed_matrix_egress.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(var.computed_matrix_egress.prefix_list_ids, null)
  source_security_group_id = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
  self                     = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
  description              = null
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_matrix_egress_with_source_security_group_ids" {
  count             = try(length(var.computed_matrix_egress.source_security_group_ids) * length(var.computed_matrix_egress.rules), 0)
  security_group_id = local.security_group_id
  type              = "egress"

  # customer, managed or common rules
  from_port = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["from_port"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["to_port"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["protocol"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["protocol"]
  )

  # destinations
  cidr_blocks              = null # Cannot be specified with source_security_group_id
  ipv6_cidr_blocks         = null # Cannot be specified with source_security_group_id
  prefix_list_ids          = null # Cannot be specified with source_security_group_id
  source_security_group_id = var.computed_matrix_egress.source_security_group_ids[count.index % length(var.computed_matrix_egress.rules)]
  self                     = null # Cannot be specified with source_security_group_id
  description              = null
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_matrix_egress_with_self" {
  count             = try(var.computed_matrix_egress.self ? length(var.computed_matrix_egress.rules) : 0, 0)
  security_group_id = local.security_group_id
  type              = "egress"

  # customer, managed or common rules
  from_port = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["from_port"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["to_port"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["rule"]]["protocol"],
    var.computed_matrix_egress.rules[count.index % length(var.computed_matrix_egress.rules)]["protocol"]
  )

  # destinations
  cidr_blocks              = null # Cannot be specified with self
  ipv6_cidr_blocks         = null # Cannot be specified with self
  prefix_list_ids          = null # Cannot be specified with self
  source_security_group_id = null # Cannot be specified with self
  self                     = true
  description              = null
}
