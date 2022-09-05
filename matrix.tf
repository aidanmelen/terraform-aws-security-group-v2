###############################################################################
# Matrix Security Group Rules
###############################################################################

locals {
  matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count = var.create && anytrue([
    length(try(var.matrix_ingress.cidr_blocks, [])) > 0,
    length(try(var.matrix_ingress.ipv6_cidr_blocks, [])) > 0,
    length(try(var.matrix_ingress.prefix_list_ids, [])) > 0,
  ]) ? length(var.matrix_ingress.rules) : 0

  matrix_ingress_with_source_security_group_id_count = var.create && (
    try(var.matrix_ingress.source_security_group_id, null) != null
  ) ? length(var.matrix_ingress.rules) : 0

  matrix_ingress_with_self_count = var.create && (
    try(var.matrix_ingress.self, null) != null
  ) ? length(var.matrix_ingress.rules) : 0

  matrix_egress_with_cidr_blocks_and_prefix_list_ids_count = var.create && anytrue([
    length(try(var.matrix_egress.cidr_blocks, [])) > 0,
    length(try(var.matrix_egress.ipv6_cidr_blocks, [])) > 0,
    length(try(var.matrix_egress.prefix_list_ids, [])) > 0,
  ]) ? length(var.matrix_egress.rules) : 0

  matrix_egress_with_source_security_group_id_count = var.create && (
    try(var.matrix_egress.source_security_group_id, null) != null
  ) ? length(var.matrix_egress.rules) : 0

  matrix_egress_with_self_count = var.create && (
    try(var.matrix_egress.self, null) != null
  ) ? length(var.matrix_egress.rules) : 0
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_ingress" {
  count = (
    local.matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count +
    local.matrix_ingress_with_source_security_group_id_count +
    local.matrix_ingress_with_self_count
  )

  security_group_id = local.security_group_id
  type              = "ingress"
  description       = try(var.matrix_ingress.description, "matrix rule managed by Terraform")

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
  cidr_blocks = (
    count.index < local.matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count ?
    try(var.matrix_ingress.cidr_blocks, null) : null
  )
  ipv6_cidr_blocks = (
    count.index < local.matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count ?
    try(var.matrix_ingress.ipv6_cidr_blocks, null) : null
  )
  prefix_list_ids = (
    count.index < local.matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count ?
    try(var.matrix_ingress.prefix_list_ids, null) : null
  )
  source_security_group_id = (
    count.index >= local.matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count &&
    count.index < (
      local.matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count +
      local.matrix_ingress_with_source_security_group_id_count
    ) ?
    try(var.matrix_ingress.source_security_group_id, null) : null
  )
  self = (
    count.index >= (
      local.matrix_ingress_with_cidr_blocks_and_prefix_list_ids_count +
      local.matrix_ingress_with_source_security_group_id_count
    ) ?
    try(var.matrix_ingress.self, null) : null
  )
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "matrix_egress" {
  count = (
    local.matrix_egress_with_cidr_blocks_and_prefix_list_ids_count +
    local.matrix_egress_with_source_security_group_id_count +
    local.matrix_egress_with_self_count
  )

  security_group_id = local.security_group_id
  type              = "egress"
  description       = try(var.matrix_egress.description, "matrix rule managed by Terraform")

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
  cidr_blocks = (
    count.index < local.matrix_egress_with_cidr_blocks_and_prefix_list_ids_count ?
    try(var.matrix_egress.cidr_blocks, null) : null
  )
  ipv6_cidr_blocks = (
    count.index < local.matrix_egress_with_cidr_blocks_and_prefix_list_ids_count ?
    try(var.matrix_egress.ipv6_cidr_blocks, null) : null
  )
  prefix_list_ids = (
    count.index < local.matrix_egress_with_cidr_blocks_and_prefix_list_ids_count ?
    try(var.matrix_egress.prefix_list_ids, null) : null
  )
  source_security_group_id = (
    count.index >= local.matrix_egress_with_cidr_blocks_and_prefix_list_ids_count &&
    count.index < (
      local.matrix_egress_with_cidr_blocks_and_prefix_list_ids_count +
      local.matrix_egress_with_source_security_group_id_count
    ) ?
    try(var.matrix_egress.source_security_group_id, null) : null
  )
  self = (
    count.index >= (
      local.matrix_egress_with_cidr_blocks_and_prefix_list_ids_count +
      local.matrix_egress_with_source_security_group_id_count
    ) ?
    try(var.matrix_egress.self, null) : null
  )
}
