###############################################################################
# Computed Security Group Ingress Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_ingress_with_cidr_blocks_and_prefix_list_ids" {
  count = anytrue([
    length(lookup(var.matrix_ingress, "cidr_blocks", [])) > 0,
    length(lookup(var.matrix_ingress, "ipv6_cidr_blocks", [])) > 0,
    length(lookup(var.matrix_ingress, "prefix_list_ids", [])) > 0,
  ]) ? length(var.matrix_ingress.rules) : 0
  security_group_id = local.security_group_id
  type              = "ingress"

  description = try(
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["description"],
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["description"],
    "managed by Terraform"
  )

  from_port = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["from_port"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["to_port"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["protocol"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["protocol"]
  )

  cidr_blocks              = try(var.matrix_ingress.cidr_blocks, null)
  ipv6_cidr_blocks         = try(var.matrix_ingress.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(var.matrix_ingress.prefix_list_ids, null)
  source_security_group_id = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
  self                     = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_ingress_with_source_security_group_id" {
  count             = try(var.create && var.matrix_ingress.source_security_group_id != null ? length(var.matrix_ingress.rules) : 0, 0)
  security_group_id = local.security_group_id
  type              = "ingress"

  description = try(
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["description"],
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["description"],
    "managed by Terraform"
  )

  from_port = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["from_port"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["to_port"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["protocol"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["protocol"]
  )

  cidr_blocks              = null # Cannot be specified with source_security_group_id
  ipv6_cidr_blocks         = null # Cannot be specified with source_security_group_id
  prefix_list_ids          = null # Already specified with cidr_blocks and ipv6_cidr_blocks
  source_security_group_id = var.matrix_ingress.source_security_group_id
  self                     = null # Cannot be specified with source_security_group_id
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_ingress_with_self" {
  count             = try(var.create && var.matrix_ingress.self == true ? length(var.matrix_ingress.rules) : 0, 0)
  security_group_id = local.security_group_id
  type              = "ingress"

  description = try(
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["description"],
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["description"],
    "managed by Terraform"
  )

  from_port = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["from_port"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["to_port"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["rule"]]["protocol"],
    var.matrix_ingress.rules[count.index % length(var.matrix_ingress.rules)]["protocol"]
  )

  cidr_blocks              = null # Cannot be specified with self
  ipv6_cidr_blocks         = null # Cannot be specified with self
  prefix_list_ids          = null # Already specified with cidr_blocks and ipv6_cidr_blocks
  source_security_group_id = null # Cannot be specified with self
  self                     = true
}

###############################################################################
# Computed Security Group Egress Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_egress_with_cidr_blocks_and_prefix_list_ids" {
  count = anytrue([
    length(lookup(var.matrix_egress, "cidr_blocks", [])) > 0,
    length(lookup(var.matrix_egress, "ipv6_cidr_blocks", [])) > 0,
    length(lookup(var.matrix_egress, "prefix_list_ids", [])) > 0,
  ]) ? length(var.matrix_egress.rules) : 0
  security_group_id = local.security_group_id
  type              = "ingress"

  description = try(
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["description"],
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["description"],
    "managed by Terraform"
  )

  from_port = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["from_port"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["to_port"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["protocol"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["protocol"]
  )

  cidr_blocks              = try(var.matrix_egress.cidr_blocks, null)
  ipv6_cidr_blocks         = try(var.matrix_egress.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(var.matrix_egress.prefix_list_ids, null)
  source_security_group_id = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
  self                     = null # Cannot be specified with cidr_blocks, ipv6_cidr_blocks
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_egress_with_source_security_group_id" {
  count             = try(var.create && var.matrix_egress.source_security_group_id != null ? length(var.matrix_egress.rules) : 0, 0)
  security_group_id = local.security_group_id
  type              = "ingress"

  description = try(
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["description"],
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["description"],
    "managed by Terraform"
  )

  from_port = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["from_port"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["to_port"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["protocol"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["protocol"]
  )

  cidr_blocks              = null # Cannot be specified with source_security_group_id
  ipv6_cidr_blocks         = null # Cannot be specified with source_security_group_id
  prefix_list_ids          = null # Already specified with cidr_blocks and ipv6_cidr_blocks
  source_security_group_id = var.matrix_egress.source_security_group_id
  self                     = null # Cannot be specified with source_security_group_id
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_egress_with_self" {
  count             = try(var.create && var.matrix_egress.self == true ? length(var.matrix_egress.rules) : 0, 0)
  security_group_id = local.security_group_id
  type              = "ingress"

  description = try(
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["description"],
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["description"],
    "managed by Terraform"
  )

  from_port = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["from_port"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["from_port"]
  )
  to_port = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["to_port"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["to_port"]
  )
  protocol = try(
    local.rules[var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["rule"]]["protocol"],
    var.matrix_egress.rules[count.index % length(var.matrix_egress.rules)]["protocol"]
  )

  cidr_blocks              = null # Cannot be specified with self
  ipv6_cidr_blocks         = null # Cannot be specified with self
  prefix_list_ids          = null # Already specified with cidr_blocks and ipv6_cidr_blocks
  source_security_group_id = null # Cannot be specified with self
  self                     = true
}
