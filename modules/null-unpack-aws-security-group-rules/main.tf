locals {
  cidr_block_rules = try([
    for rule in var.rules : [

      # unpack cidr_blocks
      for cidr_block in rule.cidr_blocks : merge(
        # Required
        { cidr_blocks = [cidr_block] },

        # Optional:
        #   Assigning to null will cause the default_rule_description to fail.
        try({ description = rule.description }, {}),

        # Optional:
        #   Can be either rule OR from_port, to_port and protocol.
        #   Assigning to null will cause the try logic in the normalization code to break.
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
    ]
    if var.create && try(rule.cidr_blocks != null, false)
  ], [])

  ipv6_cidr_block_rules = try([
    for rule in var.rules : [

      # unpack ipv6_cidr_blocks
      for ipv6_cidr_block in rule.ipv6_cidr_blocks : merge(
        { ipv6_cidr_blocks = [ipv6_cidr_block] },
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
    ]
    if var.create && try(rule.ipv6_cidr_blocks != null, false)
  ], [])

  prefix_list_id_rules = try([
    for rule in var.rules : [

      # unpack prefix_list_ids
      for prefix_list_id in rule.prefix_list_ids : merge(
        { prefix_list_ids = [prefix_list_id] },
        try({ description = rule.description }, {}),
        try({ rule = rule.rule }, {}),
        try({ from_port = rule.from_port }, {}),
        try({ to_port = rule.to_port }, {}),
        try({ protocol = rule.protocol }, {}),
      )
    ]
    if var.create && try(rule.prefix_list_ids != null, false)
  ], [])

  self_rules = try([
    for rule in var.rules : merge(
      { self = rule.self },
      try({ description = rule.description }, {}),
      try({ rule = rule.rule }, {}),
      try({ from_port = rule.from_port }, {}),
      try({ to_port = rule.to_port }, {}),
      try({ protocol = rule.protocol }, {}),
    )
    if var.create && try(rule.self != null, false)
  ], [])

  source_security_group_id_rules = try([
    for rule in var.rules : merge(
      { source_security_group_id = rule.source_security_group_id },
      try({ description = rule.description }, {}),
      try({ rule = rule.rule }, {}),
      try({ from_port = rule.from_port }, {}),
      try({ to_port = rule.to_port }, {}),
      try({ protocol = rule.protocol }, {}),
    )
    if var.create && try(rule.source_security_group_id != null, false)
  ], [])

  rules = flatten(concat(
    local.cidr_block_rules,
    local.ipv6_cidr_block_rules,
    local.prefix_list_id_rules,
    local.self_rules,
    local.source_security_group_id_rules
  ))
}
