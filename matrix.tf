###############################################################################
# Security Group Matrix Rules
###############################################################################

locals {
  matrix_ingress = flatten([
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(rule, {
        type             = "ingress"
        key              = try(join("-", [rule.key, "cidr-blocks-and-prefix-list-ids"]), null)
        description      = try(var.matrix_ingress.description, rule.description, var.default_rule_description)
        cidr_blocks      = try(var.matrix_ingress.cidr_blocks, null)
        ipv6_cidr_blocks = try(var.matrix_ingress.ipv6_cidr_blocks, null)
        prefix_list_ids  = try(var.matrix_ingress.prefix_list_ids, null)
      })
      if var.create && anytrue([
        contains(keys(var.matrix_ingress), "cidr_blocks"),
        contains(keys(var.matrix_ingress), "ipv6_cidr_blocks"),
        contains(keys(var.matrix_ingress), "prefix_list_ids"),
      ])
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(rule, {
        type                     = "ingress"
        key                      = try(join("-", [rule.key, "source-security-group-id"]), null)
        description              = try(var.matrix_ingress.description, rule.description, var.default_rule_description)
        source_security_group_id = try(var.matrix_ingress.source_security_group_id, null)
      })
      if var.create && try(contains(keys(var.matrix_ingress), "source_security_group_id"), false)
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(rule, {
        type        = "ingress"
        key         = try(join("-", [rule.key, "self"]), null)
        description = try(var.matrix_ingress.description, rule.description, var.default_rule_description)
        self        = try(var.matrix_ingress.self, null)
      })
      if var.create && try(contains(keys(var.matrix_ingress), "self"), false)
    ]
  ])

  matrix_egress = flatten([
    [
      for rule in try(var.matrix_egress.rules, []) : merge(rule, {
        type             = "egress"
        key              = try(join("-", [rule.key, "cidr-blocks-and-prefix-list-ids"]), null)
        description      = try(var.matrix_egress.description, rule.description, var.default_rule_description)
        cidr_blocks      = try(var.matrix_egress.cidr_blocks, null)
        ipv6_cidr_blocks = try(var.matrix_egress.ipv6_cidr_blocks, null)
        prefix_list_ids  = try(var.matrix_egress.prefix_list_ids, null)
      })
      if var.create && anytrue([
        contains(keys(var.matrix_egress), "cidr_blocks"),
        contains(keys(var.matrix_egress), "ipv6_cidr_blocks"),
        contains(keys(var.matrix_egress), "prefix_list_ids"),
      ])
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(rule, {
        type                     = "egress"
        key                      = try(join("-", [rule.key, "source-security-group-id"]), null)
        description              = try(var.matrix_egress.description, rule.description, var.default_rule_description)
        source_security_group_id = try(var.matrix_egress.source_security_group_id, null)
      })
      if var.create && try(contains(keys(var.matrix_egress), "source_security_group_id"), false)
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(rule, {
        type        = "egress"
        key         = try(join("-", [rule.key, "self"]), null)
        description = try(var.matrix_egress.description, rule.description, var.default_rule_description)
        self        = try(var.matrix_egress.self, null)
      })
      if var.create && try(contains(keys(var.matrix_egress), "self"), false)
    ]
  ])
}

resource "aws_security_group_rule" "matrix_ingress" {
  for_each = {
    for rule in local.matrix_ingress : (
      rule.key != null ?
      rule.key :
      lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-"))
    ) => rule
  }
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "matrix_egress" {
  for_each = {
    for rule in local.matrix_egress : (
      rule.key != null ?
      rule.key :
      lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-"))
    ) => rule
  }
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

  lifecycle {
    create_before_destroy = true
  }
}
