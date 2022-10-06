###############################################################################
# Security Group Matrix Rules
###############################################################################

#
locals {
  matrix_ingress_normalized = flatten([
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
          cidr_blocks              = try(var.matrix_ingress.cidr_blocks, null)
          ipv6_cidr_blocks         = try(var.matrix_ingress.ipv6_cidr_blocks, null)
          prefix_list_ids          = try(var.matrix_ingress.prefix_list_ids, null)
          self                     = null
          source_security_group_id = null
        }
        ) if var.create && anytrue([
          try(var.matrix_ingress.cidr_blocks != null, false),
          try(var.matrix_ingress.ipv6_cidr_blocks != null, false),
          try(var.matrix_ingress.prefix_list_ids != null, false),
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
      ) if var.create && try(var.matrix_ingress.source_security_group_id != null, false)
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
      ) if var.create && try(var.matrix_ingress.self != null, false)
    ]
  ])

  matrix_egress_normalized = flatten([
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
          cidr_blocks              = try(var.matrix_egress.cidr_blocks, null)
          ipv6_cidr_blocks         = try(var.matrix_egress.ipv6_cidr_blocks, null)
          prefix_list_ids          = try(var.matrix_egress.prefix_list_ids, null)
          self                     = null
          source_security_group_id = null
        }
        ) if var.create && anytrue([
          try(var.matrix_egress.cidr_blocks != null, false),
          try(var.matrix_egress.ipv6_cidr_blocks != null, false),
          try(var.matrix_egress.prefix_list_ids != null, false),
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
      ) if var.create && try(var.matrix_egress.source_security_group_id != null, false)
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
      ) if var.create && try(var.matrix_egress.self != null, false)
    ]
  ])
}

module "matrix_ingress_unpacked" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.matrix_ingress_normalized
}

module "matrix_egress_unpacked" {
  source = "./modules/null-unpack-aws-security-group-rules"
  count  = var.unpack ? 1 : 0
  create = var.create
  rules  = local.matrix_egress_normalized
}

# create map of rules with unique keys to prevent for_each churn that occurs with a set of rules
locals {
  matrix_ingress_map = {
    for rule in try(module.matrix_ingress_unpacked[0].rules, local.matrix_ingress_normalized) : lower(join("-", compact([
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.self, null),
      try(rule.source_security_group_id, null),
    ]))) => rule
  }

  matrix_egress_map = {
    for rule in try(module.matrix_egress_unpacked[0].rules, local.matrix_egress_normalized) : lower(join("-", compact([
      try(rule.rule, null),
      try(rule.from_port, null),
      try(rule.to_port, null),
      try(rule.protocol, null),
      try(join("-", rule.cidr_blocks), null),
      try(join("-", rule.ipv6_cidr_blocks), null),
      try(join("-", rule.prefix_list_ids), null),
      try(rule.self, null),
      try(rule.source_security_group_id, null),
    ]))) => rule
  }
}

resource "aws_security_group_rule" "matrix_ingress" {
  for_each                 = local.matrix_ingress_map
  security_group_id        = local.security_group_id
  type                     = "ingress"
  description              = try(each.value.description, local.rule_aliases[each.value.rule].description, var.default_rule_description)
  from_port                = try(each.value.from_port, local.rule_aliases[each.value.rule].from_port)
  to_port                  = try(each.value.to_port, local.rule_aliases[each.value.rule].to_port)
  protocol                 = try(each.value.protocol, local.rule_aliases[each.value.rule].protocol)
  cidr_blocks              = try(each.value.cidr_blocks, local.rule_aliases[each.value.rule].cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, local.rule_aliases[each.value.rule].ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, local.rule_aliases[each.value.rule].prefix_list_ids, null)
  self                     = try(each.value.self, local.rule_aliases[each.value.rule].self, null)
  source_security_group_id = try(each.value.source_security_group_id, local.rule_aliases[each.value.rule].source_security_group_id, null)
}

resource "aws_security_group_rule" "matrix_egress" {
  for_each                 = local.matrix_egress_map
  security_group_id        = local.security_group_id
  type                     = "egress"
  description              = try(each.value.description, local.rule_aliases[each.value.rule].description, var.default_rule_description)
  from_port                = try(each.value.from_port, local.rule_aliases[each.value.rule].from_port)
  to_port                  = try(each.value.to_port, local.rule_aliases[each.value.rule].to_port)
  protocol                 = try(each.value.protocol, local.rule_aliases[each.value.rule].protocol)
  cidr_blocks              = try(each.value.cidr_blocks, local.rule_aliases[each.value.rule].cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, local.rule_aliases[each.value.rule].ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, local.rule_aliases[each.value.rule].prefix_list_ids, null)
  self                     = try(each.value.self, local.rule_aliases[each.value.rule].self, null)
  source_security_group_id = try(each.value.source_security_group_id, local.rule_aliases[each.value.rule].source_security_group_id, null)
}
