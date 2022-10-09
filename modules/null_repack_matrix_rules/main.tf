locals {
  cidr_blocks_and_prefix_list_ids_matrix_rules = [
    for rule in try(var.matrix.rules, []) : {
      description              = try(rule.description, null),
      rule                     = try(rule.rule, null),
      from_port                = try(rule.from_port, null),
      to_port                  = try(rule.to_port, null),
      protocol                 = try(rule.protocol, null),
      cidr_blocks              = try(var.matrix.cidr_blocks, var.matrix.managed_rule_aliases[rule.rule].cidr_blocks, null),
      ipv6_cidr_blocks         = try(var.matrix.ipv6_cidr_blocks, var.matrix.managed_rule_aliases[rule.rule].ipv6_cidr_blocks, null),
      prefix_list_ids          = try(var.matrix.prefix_list_ids, var.matrix.managed_rule_aliases[rule.rule].prefix_list_ids, null)
      self                     = null,
      source_security_group_id = null,
    }
    if var.create && anytrue([
      try(var.matrix.cidr_blocks != null, false),
      try(var.matrix.ipv6_cidr_blocks != null, false),
      try(var.matrix.prefix_list_ids != null, false),
    ])
  ]

  source_security_group_id_matrix_rules = [
    for rule in try(var.matrix.rules, []) : {
      description              = try(rule.description, null),
      rule                     = try(rule.rule, null),
      from_port                = try(rule.from_port, null),
      to_port                  = try(rule.to_port, null),
      protocol                 = try(rule.protocol, null),
      cidr_blocks              = null,
      ipv6_cidr_blocks         = null,
      prefix_list_ids          = null,
      self                     = null,
      source_security_group_id = try(var.matrix.source_security_group_id, null),
    }
    if var.create && try(var.matrix.source_security_group_id != null, false)
  ]

  self_matrix_rules = [
    for rule in try(var.matrix.rules, []) : {
      description              = try(rule.description, null),
      rule                     = try(rule.rule, null),
      from_port                = try(rule.from_port, null),
      to_port                  = try(rule.to_port, null),
      protocol                 = try(rule.protocol, null),
      cidr_blocks              = null
      ipv6_cidr_blocks         = null
      prefix_list_ids          = null
      self                     = try(var.matrix.self, null)
      source_security_group_id = null
    }
    if var.create && try(var.matrix.self != null, false)
  ]

  rules = [
    for rule in flatten(concat(
      local.cidr_blocks_and_prefix_list_ids_matrix_rules,
      local.source_security_group_id_matrix_rules,
      local.self_matrix_rules,
      )) : {
      # prune rule map of k,v where v is null
      # otherwise, try function precendence during normalization will break
      for k, v in rule : k => v if v != null
    }
  ]
}
