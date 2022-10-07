###############################################################################
# Security Group Matrix Rules
###############################################################################

locals {

  # flatten matrix rules and group compatible security group rule arguments
  matrix_ingress_flatten = flatten([
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(
        {
          description      = try(rule.description, var.matrix_ingress.description)
          cidr_blocks      = try(var.matrix_ingress.cidr_blocks, null)
          ipv6_cidr_blocks = try(var.matrix_ingress.ipv6_cidr_blocks, null)
          prefix_list_ids  = try(var.matrix_ingress.prefix_list_ids, null)
          # incompatible rules must be assigned null otherwise the object types in the list will not match
          self                     = null
          source_security_group_id = null
        },
        # Optional:
        #   Can be either rule OR from_port, to_port and protocol.
        #   Assigning to null will cause the try logic in the normalization code to break.
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
      if var.create && anytrue([
        try(var.matrix_ingress.cidr_blocks != null, false),
        try(var.matrix_ingress.ipv6_cidr_blocks != null, false),
        try(var.matrix_ingress.prefix_list_ids != null, false),
      ])
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(
        {
          description              = try(rule.description, var.matrix_ingress.description)
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = null
          source_security_group_id = try(var.matrix_ingress.source_security_group_id, null)
        },
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
      if var.create && try(var.matrix_ingress.source_security_group_id != null, false)
    ],
    [
      for rule in try(var.matrix_ingress.rules, []) : merge(
        {
          description              = try(rule.description, var.matrix_ingress.description)
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = try(var.matrix_ingress.self, null)
          source_security_group_id = null
        },
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
      if var.create && try(var.matrix_ingress.self != null, false)
    ]
  ])

  matrix_egress_flatten = flatten([
    [
      for rule in try(var.matrix_egress.rules, []) : merge(
        {
          description              = try(rule.description, var.matrix_egress.description)
          cidr_blocks              = try(var.matrix_egress.cidr_blocks, null)
          ipv6_cidr_blocks         = try(var.matrix_egress.ipv6_cidr_blocks, null)
          prefix_list_ids          = try(var.matrix_egress.prefix_list_ids, null)
          self                     = null
          source_security_group_id = null
        },
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
      if var.create && anytrue([
        try(var.matrix_egress.cidr_blocks != null, false),
        try(var.matrix_egress.ipv6_cidr_blocks != null, false),
        try(var.matrix_egress.prefix_list_ids != null, false),
      ])
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(
        {
          description              = try(rule.description, var.matrix_egress.description)
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = null
          source_security_group_id = try(var.matrix_egress.source_security_group_id, null)
        },
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
      if var.create && try(var.matrix_egress.source_security_group_id != null, false)
    ],
    [
      for rule in try(var.matrix_egress.rules, []) : merge(
        {
          description              = try(rule.description, var.matrix_egress.description)
          cidr_blocks              = null
          ipv6_cidr_blocks         = null
          prefix_list_ids          = null
          self                     = try(var.matrix_egress.self, null)
          source_security_group_id = null
        },
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
      if var.create && try(var.matrix_egress.self != null, false)
    ]
  ])

  # normalize customer, managed and common rules
  matrix_ingress_normalized = [
    for rule in local.matrix_ingress_flatten : {
      description              = try(rule.description, local.rule_aliases[rule.rule].description, var.default_rule_description)
      from_port                = try(rule.from_port, local.rule_aliases[rule.rule].from_port)
      to_port                  = try(rule.to_port, local.rule_aliases[rule.rule].to_port)
      protocol                 = try(rule.protocol, local.rule_aliases[rule.rule].protocol)
      cidr_blocks              = try(rule.cidr_blocks, local.rule_aliases[rule.rule].cidr_blocks, null)
      ipv6_cidr_blocks         = try(rule.ipv6_cidr_blocks, local.rule_aliases[rule.rule].ipv6_cidr_blocks, null)
      prefix_list_ids          = try(rule.prefix_list_ids, local.rule_aliases[rule.rule].prefix_list_ids, null)
      self                     = try(rule.self, local.rule_aliases[rule.rule].self, null)
      source_security_group_id = try(rule.source_security_group_id, local.rule_aliases[rule.rule].source_security_group_id, null)
    }
    if var.create
  ]

  matrix_egress_normalized = [
    for rule in local.matrix_egress_flatten : {
      description              = try(rule.description, local.rule_aliases[rule.rule].description, var.default_rule_description)
      from_port                = try(rule.from_port, local.rule_aliases[rule.rule].from_port)
      to_port                  = try(rule.to_port, local.rule_aliases[rule.rule].to_port)
      protocol                 = try(rule.protocol, local.rule_aliases[rule.rule].protocol)
      cidr_blocks              = try(rule.cidr_blocks, local.rule_aliases[rule.rule].cidr_blocks, null)
      ipv6_cidr_blocks         = try(rule.ipv6_cidr_blocks, local.rule_aliases[rule.rule].ipv6_cidr_blocks, null)
      prefix_list_ids          = try(rule.prefix_list_ids, local.rule_aliases[rule.rule].prefix_list_ids, null)
      self                     = try(rule.self, local.rule_aliases[rule.rule].self, null)
      source_security_group_id = try(rule.source_security_group_id, local.rule_aliases[rule.rule].source_security_group_id, null)
    }
    if var.create
  ]
}

# unpack grouped security rules
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
  description              = try(each.value.description, null)
  from_port                = try(each.value.from_port, null)
  to_port                  = try(each.value.to_port, null)
  protocol                 = try(each.value.protocol, null)
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}

resource "aws_security_group_rule" "matrix_egress" {
  for_each                 = local.matrix_egress_map
  security_group_id        = local.security_group_id
  type                     = "egress"
  description              = try(each.value.description, null)
  from_port                = try(each.value.from_port, null)
  to_port                  = try(each.value.to_port, null)
  protocol                 = try(each.value.protocol, null)
  cidr_blocks              = try(each.value.cidr_blocks, null)
  ipv6_cidr_blocks         = try(each.value.ipv6_cidr_blocks, null)
  prefix_list_ids          = try(each.value.prefix_list_ids, null)
  self                     = try(each.value.self, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
}
