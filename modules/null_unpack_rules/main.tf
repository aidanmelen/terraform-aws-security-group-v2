locals {
  cidr_block_rules = try([
    for rule in var.rules : [

      # unpack cidr_blocks list elements
      for cidr_block in rule.cidr_blocks : {
        description = try(rule.description, null),
        rule        = try(rule.rule, null),
        from_port   = try(rule.from_port, null),
        to_port     = try(rule.to_port, null),
        protocol    = try(rule.protocol, null),
        cidr_blocks = try([cidr_block], null),
      }
    ]
    if var.create && try(rule.cidr_blocks != null, false)
  ], [])

  ipv6_cidr_block_rules = try([
    for rule in var.rules : [

      # unpack ipv6_cidr_blocks list elements
      for ipv6_cidr_block in rule.ipv6_cidr_blocks : {
        description      = try(rule.description, null),
        rule             = try(rule.rule, null),
        from_port        = try(rule.from_port, null),
        to_port          = try(rule.to_port, null),
        protocol         = try(rule.protocol, null),
        ipv6_cidr_blocks = try([ipv6_cidr_block], null),
      }
    ]
    if var.create && try(rule.ipv6_cidr_blocks != null, false)
  ], [])

  prefix_list_id_rules = try([
    for rule in var.rules : [

      # unpack prefix_list_ids list elements
      for prefix_list_id in rule.prefix_list_ids : {
        description     = try(rule.description, null),
        rule            = try(rule.rule, null),
        from_port       = try(rule.from_port, null),
        to_port         = try(rule.to_port, null),
        protocol        = try(rule.protocol, null),
        prefix_list_ids = try([prefix_list_id], null),
      }
    ]
    if var.create && try(rule.prefix_list_ids != null, false)
  ], [])

  self_rules = try([
    for rule in var.rules : {
      description = try(rule.description, null),
      rule        = try(rule.rule, null),
      from_port   = try(rule.from_port, null),
      to_port     = try(rule.to_port, null),
      protocol    = try(rule.protocol, null),
      self        = try(rule.self, null),
    }
    if var.create && try(rule.self != null, false)
  ], [])

  source_security_group_id_rules = try([
    for rule in var.rules : {
      description              = try(rule.description, null),
      rule                     = try(rule.rule, null),
      from_port                = try(rule.from_port, null),
      to_port                  = try(rule.to_port, null),
      protocol                 = try(rule.protocol, null),
      source_security_group_id = try(rule.source_security_group_id, null),
    }
    if var.create && try(rule.source_security_group_id != null, false)
  ], [])

  rules = [
    for rule in flatten(concat(
      local.cidr_block_rules,
      local.ipv6_cidr_block_rules,
      local.prefix_list_id_rules,
      local.self_rules,
      local.source_security_group_id_rules,
      )) : {
      # prune rule map of k,v where v is null
      # otherwise, try function precendence during normalization will break
      for k, v in rule : k => v if v != null
    }
  ]
}
