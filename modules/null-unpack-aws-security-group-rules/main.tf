locals {
  cidr_block_rules = try([
    for rule in var.rules : [
      for cidr_block in rule.cidr_blocks : merge(
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        { cidr_blocks = [cidr_block] }
      )
    ]
    if try(rule.cidr_blocks != null, false)
  ], [])

  ipv6_cidr_block_rules = try([
    for rule in var.rules : [
      for ipv6_cidr_block in rule.ipv6_cidr_blocks : merge(
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        { ipv6_cidr_blocks = [ipv6_cidr_block] }
      )
    ]
    if try(rule.ipv6_cidr_blocks != null, false)
  ], [])

  prefix_list_id_rules = try([
    for rule in var.rules : [
      for prefix_list_id in rule.prefix_list_ids : merge(
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
        { prefix_list_ids = [prefix_list_id] }
      )
    ]
    if try(rule.prefix_list_id != null, false)
  ], [])

  self_rules = try([
    for rule in var.rules : merge(
      try({ description = rule.description }, {}),
      try({ rule = rule.rule }, {}),
      try({ from_port = rule.from_port }, {}),
      try({ to_port = rule.to_port }, {}),
      try({ protocol = rule.protocol }, {}),
      { self = rule.self }
    )
    if try(rule.self != null, false)
  ], [])

  source_security_group_id_rules = try([
    for rule in var.rules : merge(
      try({ description = rule.description }, {}),
      try({ rule = rule.rule }, {}),
      try({ from_port = rule.from_port }, {}),
      try({ to_port = rule.to_port }, {}),
      try({ protocol = rule.protocol }, {}),
      { source_security_group_id = rule.source_security_group_id }
    )
    if try(rule.source_security_group_id != null, false)
  ], [])

  rules = var.create ? flatten(concat(
    local.cidr_block_rules,
    local.ipv6_cidr_block_rules,
    local.prefix_list_id_rules,
    local.self_rules,
    local.source_security_group_id_rules
  )) : []
}
