###############################################################################
# Security Group Matrix Rules
###############################################################################

locals {
  matrix_ingress = flatten([
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(rule, {
        "description"      = try(var.matrix_ingress.description, rule.description, "managed by Terraform")
        "cidr_blocks"      = try(var.matrix_ingress.cidr_blocks, null)
        "ipv6_cidr_blocks" = try(var.matrix_ingress.ipv6_cidr_blocks, null)
        "prefix_list_ids"  = try(var.matrix_ingress.prefix_list_ids, null)
      })
      if var.create && anytrue([
        contains(keys(var.matrix_ingress), "cidr_blocks"),
        contains(keys(var.matrix_ingress), "ipv6_cidr_blocks"),
        contains(keys(var.matrix_ingress), "prefix_list_ids"),
      ])
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(rule, {
        "description"              = try(var.matrix_ingress.description, rule.description, "managed by Terraform")
        "source_security_group_id" = try(var.matrix_ingress.source_security_group_id, null)
      })
      if var.create && try(contains(keys(var.matrix_ingress), "source_security_group_id"), false)
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(rule, {
        "description" = try(var.matrix_ingress.description, rule.description, "managed by Terraform")
        "self"        = try(var.matrix_ingress.self, null)
      })
      if var.create && try(contains(keys(var.matrix_ingress), "self"), false)
    ]
  ])

  matrix_egress = flatten([
    [
      for rule in try(var.matrix_egress.rules, []) : merge(rule, {
        "description"      = try(var.matrix_egress.description, rule.description, "managed by Terraform")
        "cidr_blocks"      = try(var.matrix_egress.cidr_blocks, null)
        "ipv6_cidr_blocks" = try(var.matrix_egress.ipv6_cidr_blocks, null)
        "prefix_list_ids"  = try(var.matrix_egress.prefix_list_ids, null)
      })
      if var.create && anytrue([
        contains(keys(var.matrix_egress), "cidr_blocks"),
        contains(keys(var.matrix_egress), "ipv6_cidr_blocks"),
        contains(keys(var.matrix_egress), "prefix_list_ids"),
      ])
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(rule, {
        "description"              = try(var.matrix_egress.description, rule.description, "managed by Terraform")
        "source_security_group_id" = try(var.matrix_egress.source_security_group_id, null)
      })
      if var.create && try(contains(keys(var.matrix_egress), "source_security_group_id"), false)
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(rule, {
        "description" = try(var.matrix_egress.description, rule.description, "managed by Terraform")
        "self"        = try(var.matrix_egress.self, null)
      })
      if var.create && try(contains(keys(var.matrix_egress), "self"), false)
    ]
  ])
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "matrix_ingress" {
  for_each = {
    for rule in local.matrix_ingress : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule
  }
  security_group_id        = local.security_group_id
  type                     = "ingress"
  description              = try(each.value["description"], local.rules[each.value["rule"]]["description"], "managed by Terraform")
  from_port                = try(each.value["from_port"], local.rules[each.value["rule"]]["from_port"])
  to_port                  = try(each.value["to_port"], local.rules[each.value["rule"]]["to_port"])
  protocol                 = try(each.value["protocol"], local.rules[each.value["rule"]]["protocol"])
  cidr_blocks              = try(each.value["cidr_blocks"], local.rules[each.value["rule"]]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(each.value["ipv6_cidr_blocks"], local.rules[each.value["rule"]]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(each.value["prefix_list_ids"], local.rules[each.value["rule"]]["prefix_list_ids"], null)
  self                     = try(each.value["self"], local.rules[each.value["rule"]]["self"], null)
  source_security_group_id = try(each.value["source_security_group_id"], local.rules[each.value["rule"]]["source_security_group_id"], null)
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "matrix_egress" {
  for_each = {
    for rule in local.matrix_egress : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule
  }
  security_group_id        = local.security_group_id
  type                     = "egress"
  description              = try(each.value["description"], local.rules[each.value["rule"]]["description"], "managed by Terraform")
  from_port                = try(each.value["from_port"], local.rules[each.value["rule"]]["from_port"])
  to_port                  = try(each.value["to_port"], local.rules[each.value["rule"]]["to_port"])
  protocol                 = try(each.value["protocol"], local.rules[each.value["rule"]]["protocol"])
  cidr_blocks              = try(each.value["cidr_blocks"], local.rules[each.value["rule"]]["cidr_blocks"], null)
  ipv6_cidr_blocks         = try(each.value["ipv6_cidr_blocks"], local.rules[each.value["rule"]]["ipv6_cidr_blocks"], null)
  prefix_list_ids          = try(each.value["prefix_list_ids"], local.rules[each.value["rule"]]["prefix_list_ids"], null)
  self                     = try(each.value["self"], local.rules[each.value["rule"]]["self"], null)
  source_security_group_id = try(each.value["source_security_group_id"], local.rules[each.value["rule"]]["source_security_group_id"], null)
}
