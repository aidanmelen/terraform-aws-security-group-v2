###############################################################################
# Security Group Matrix Rules
###############################################################################

locals {
  normalize_matrix_ingress = flatten([
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(
        try({ description = var.matrix_ingress.description }, {}),
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        {
          type                     = "ingress"
          cidr_blocks              = try(var.matrix_ingress.cidr_blocks, [])
          ipv6_cidr_blocks         = try(var.matrix_ingress.ipv6_cidr_blocks, [])
          prefix_list_ids          = try(var.matrix_ingress.prefix_list_ids, [])
          self                     = null
          source_security_group_id = null
        }
        ) if var.create && anytrue([
          contains(keys(var.matrix_ingress), "cidr_blocks"),
          contains(keys(var.matrix_ingress), "ipv6_cidr_blocks"),
          contains(keys(var.matrix_ingress), "prefix_list_ids"),
      ])
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(
        try({ description = var.matrix_ingress.description }, {}),
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        {
          type                     = "ingress"
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = null
          source_security_group_id = try(var.matrix_ingress.source_security_group_id, null)
        }
      ) if var.create && try(contains(keys(var.matrix_ingress), "source_security_group_id"), false)
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(
        try({ description = var.matrix_ingress.description }, {}),
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        {
          type                     = "ingress"
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = try(var.matrix_ingress.self, null)
          source_security_group_id = null
        }
      ) if var.create && try(contains(keys(var.matrix_ingress), "self"), false)
    ]
  ])

  normalize_matrix_egress = flatten([
    [
      for rule in try(var.matrix_egress.rules, []) : merge(
        try({ description = var.matrix_egress.description }, {}),
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        {
          type                     = "egress"
          cidr_blocks              = try(var.matrix_egress.cidr_blocks, [])
          ipv6_cidr_blocks         = try(var.matrix_egress.ipv6_cidr_blocks, [])
          prefix_list_ids          = try(var.matrix_egress.prefix_list_ids, [])
          self                     = null
          source_security_group_id = null
        }
        ) if var.create && anytrue([
          contains(keys(var.matrix_egress), "cidr_blocks"),
          contains(keys(var.matrix_egress), "ipv6_cidr_blocks"),
          contains(keys(var.matrix_egress), "prefix_list_ids"),
      ])
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(
        try({ description = var.matrix_egress.description }, {}),
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        {
          type                     = "egress"
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = null
          source_security_group_id = try(var.matrix_egress.source_security_group_id, null)
        }
      ) if var.create && try(contains(keys(var.matrix_egress), "source_security_group_id"), false)
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(
        try({ description = var.matrix_egress.description }, {}),
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        {
          type                     = "egress"
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = try(var.matrix_egress.self, null)
          source_security_group_id = null
        }
      ) if var.create && try(contains(keys(var.matrix_egress), "self"), false)
    ]
  ])
}

module "unpack_matrix_ingress" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.normalize_matrix_ingress
}

module "unpack_matrix_egress" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.normalize_matrix_egress
}

resource "aws_security_group_rule" "matrix_ingress" {
  for_each = try(
    module.unpack_matrix_ingress.rules[0],
    {
      for rule in local.normalize_matrix_ingress : lower(join("-", compact([
        "ingress",
        try(rule.rule, null),
        try(rule.from_port, null),
        try(rule.to_port, null),
        try(rule.protocol, null),
        try(join("-", rule.cidr_blocks), null),
        try(join("-", rule.ipv6_cidr_blocks), null),
        try(join("-", rule.prefix_list_ids), null),
        try(rule.self, null),
        try(rule.source_security_group_id, null),
      ]))) => rule if var.create
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
    module.unpack_matrix_egress.rules[0],
    {
      for rule in local.normalize_matrix_egress : lower(join("-", compact([
        "egress",
        try(rule.rule, null),
        try(rule.from_port, null),
        try(rule.to_port, null),
        try(rule.protocol, null),
        try(join("-", rule.cidr_blocks), null),
        try(join("-", rule.ipv6_cidr_blocks), null),
        try(join("-", rule.prefix_list_ids), null),
        try(rule.self, null),
        try(rule.source_security_group_id, null),
      ]))) => rule if var.create
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
