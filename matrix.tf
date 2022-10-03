###############################################################################
# Security Group Matrix Rules
###############################################################################

locals {
  normalize_matrix_ingress = [
    for rule in var.matrix_ingress.rules : merge(
      try({ description = var.matrix_ingress.description }, {}),
      try({ description = rule.description }, {}),
      {
        type                     = "ingress"
        rule                     = try(rule.rule, null)
        from_port                = try(rule.from_port, null)
        to_port                  = try(rule.to_port, null)
        protocol                 = try(rule.protocol, null)
        cidr_blocks              = try(var.matrix_ingress.cidr_blocks, [])
        ipv6_cidr_blocks         = try(var.matrix_ingress.ipv6_cidr_blocks, [])
        prefix_list_ids          = try(var.matrix_ingress.prefix_list_ids, [])
        source_security_group_id = try(var.matrix_ingress.source_security_group_id, null)
        self                     = try(var.matrix_ingress.self, null)
      }
    )
  ]

  normalize_matrix_egress = [
    for rule in var.matrix_egress.rules : merge(
      try({ description = var.matrix_egress.description }, {}),
      try({ description = rule.description }, {}),
      {
        type                     = "egress"
        rule                     = try(rule.rule, null)
        from_port                = try(rule.from_port, null)
        to_port                  = try(rule.to_port, null)
        protocol                 = try(rule.protocol, null)
        cidr_blocks              = try(var.matrix_egress.cidr_blocks, [])
        ipv6_cidr_blocks         = try(var.matrix_egress.ipv6_cidr_blocks, [])
        prefix_list_ids          = try(var.matrix_egress.prefix_list_ids, [])
        source_security_group_id = try(var.matrix_egress.source_security_group_id, null)
        self                     = try(var.matrix_egress.self, null)
      }
    )
  ]
}

module "expand_matrix_ingress" {
  source = "./modules/null-expand-aws-security-group-rules"
  count  = var.expand ? 1 : 0
  create = var.create
  rules  = local.normalize_matrix_ingress
}

module "expand_matrix_egress" {
  source = "./modules/null-expand-aws-security-group-rules"
  count  = var.expand ? 1 : 0
  create = var.create
  rules  = local.normalize_matrix_egress
}

resource "aws_security_group_rule" "matrix_ingress" {
  for_each = try(
    module.expand_matrix_ingress.rules[0],
    {
      for rule in local.normalize_matrix_ingress :
      lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule
    }
  )
  security_group_id        = local.security_group_id
  type                     = "ingress"
  description              = try(each.value.description, local.rules[each.value.rule].description, var.default_rule_description)
  from_port                = try(each.value.from_port, local.rules[each.value.rule].from_port)
  to_port                  = try(each.value.to_port, local.rules[each.value.rule].to_port)
  protocol                 = try(each.value.protocol, local.rules[each.value.rule].protocol)
  cidr_blocks              = try(each.value.cidr_blocks, local.rules[each.value.rule].cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, local.rules[each.value.rule].ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, local.rules[each.value.rule].prefix_list_ids, null)
  self                     = try(each.value.self, local.rules[each.value.rule].self, null)
  source_security_group_id = try(each.value.source_security_group_id, local.rules[each.value.rule].source_security_group_id, null)
}

resource "aws_security_group_rule" "matrix_egress" {
  for_each = try(
    module.expand_matrix_egress.rules[0],
    {
      for rule in local.normalize_matrix_egress :
      lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule
    }
  )
  security_group_id        = local.security_group_id
  type                     = "egress"
  description              = try(each.value.description, local.rules[each.value.rule].description, var.default_rule_description)
  from_port                = try(each.value.from_port, local.rules[each.value.rule].from_port)
  to_port                  = try(each.value.to_port, local.rules[each.value.rule].to_port)
  protocol                 = try(each.value.protocol, local.rules[each.value.rule].protocol)
  cidr_blocks              = try(each.value.cidr_blocks, local.rules[each.value.rule].cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, local.rules[each.value.rule].ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, local.rules[each.value.rule].prefix_list_ids, null)
  self                     = try(each.value.self, local.rules[each.value.rule].self, null)
  source_security_group_id = try(each.value.source_security_group_id, local.rules[each.value.rule].source_security_group_id, null)
}
