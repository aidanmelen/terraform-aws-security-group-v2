###############################################################################
# Computed Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_ingress" {
  count             = var.create ? length(var.computed_ingress) : 0
  security_group_id = local.security_group_id
  type              = "ingress"
  description = try(
    var.computed_ingress[count.index]["description"],
    local.rules[var.computed_ingress[count.index]["rule"]]["description"],
    "managed by Terraform"
  )
  from_port = try(
    var.computed_ingress[count.index]["from_port"],
    local.rules[var.computed_ingress[count.index]["rule"]]["from_port"]
  )
  to_port = try(
    var.computed_ingress[count.index]["to_port"],
    local.rules[var.computed_ingress[count.index]["rule"]]["to_port"]
  )
  protocol = try(
    var.computed_ingress[count.index]["protocol"],
    local.rules[var.computed_ingress[count.index]["rule"]]["protocol"]
  )
  cidr_blocks = try(
    var.computed_ingress[count.index]["cidr_blocks"],
    local.rules[var.computed_ingress[count.index]["rule"]]["cidr_blocks"],
    null
  )
  ipv6_cidr_blocks = try(
    var.computed_ingress[count.index]["ipv6_cidr_blocks"],
    local.rules[var.computed_ingress[count.index]["rule"]]["ipv6_cidr_blocks"],
    null
  )
  prefix_list_ids = try(
    var.computed_ingress[count.index]["prefix_list_ids"],
    local.rules[var.computed_ingress[count.index]["rule"]]["prefix_list_ids"],
    null
  )
  self = try(
    var.computed_ingress[count.index]["self"],
    local.rules[var.computed_ingress[count.index]["rule"]]["self"],
    null
  )
  source_security_group_id = try(
    var.computed_ingress[count.index]["source_security_group_id"],
    local.rules[var.computed_ingress[count.index]["rule"]]["source_security_group_id"],
    null
  )
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_egress" {
  count             = var.create ? length(var.computed_egress) : 0
  security_group_id = local.security_group_id
  type              = "egress"
  description = try(
    var.computed_egress[count.index]["description"],
    local.rules[var.computed_egress[count.index]["rule"]]["description"],
    "managed by Terraform"
  )
  from_port = try(
    var.computed_egress[count.index]["from_port"],
    local.rules[var.computed_egress[count.index]["rule"]]["from_port"]
  )
  to_port = try(
    var.computed_egress[count.index]["to_port"],
    local.rules[var.computed_egress[count.index]["rule"]]["to_port"]
  )
  protocol = try(
    var.computed_egress[count.index]["protocol"],
    local.rules[var.computed_egress[count.index]["rule"]]["protocol"]
  )
  cidr_blocks = try(
    var.computed_egress[count.index]["cidr_blocks"],
    local.rules[var.computed_egress[count.index]["rule"]]["cidr_blocks"],
    null
  )
  ipv6_cidr_blocks = try(
    var.computed_egress[count.index]["ipv6_cidr_blocks"],
    local.rules[var.computed_egress[count.index]["rule"]]["ipv6_cidr_blocks"],
    null
  )
  prefix_list_ids = try(
    var.computed_egress[count.index]["prefix_list_ids"],
    local.rules[var.computed_egress[count.index]["rule"]]["prefix_list_ids"],
    null
  )
  self = try(
    var.computed_egress[count.index]["self"],
    local.rules[var.computed_egress[count.index]["rule"]]["self"],
    null
  )
  source_security_group_id = try(
    var.computed_egress[count.index]["source_security_group_id"],
    local.rules[var.computed_egress[count.index]["rule"]]["source_security_group_id"],
    null
  )
}
