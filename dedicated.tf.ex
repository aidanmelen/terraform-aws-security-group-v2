###############################################################################
# Security Group Dedicated Rules
###############################################################################

# flatten module rules such that each security group rule resource creates exactly on security group rule.
locals {
  dedicated_ingress = {
    for rule in flatten([
      for _rule in var.dedicated_ingress : flatten([
        [
          for cidr_block in try(_rule.cidr_blocks, []) : merge(_rule, {
            type        = "ingress"
            cidr_blocks = [cidr_block]
          })
          if var.create && try(contains(keys(_rule), "cidr_blocks"), false)
        ],
        [
          for ipv6_cidr_block in try(_rule.ipv6_cidr_blocks, []) : merge(_rule, {
            type             = "ingress"
            ipv6_cidr_blocks = [ipv6_cidr_block]
          })
          if var.create && try(contains(keys(_rule), "ipv6_cidr_block"), false)
        ],
        [
          for prefix_list_id in try(_rule.prefix_list_ids, []) : merge(_rule, {
            type            = "ingress"
            prefix_list_ids = [prefix_list_id]
          })
          if var.create && try(contains(keys(_rule), "prefix_list_ids"), false)
        ],
        [
          for source_security_group_id in [try(_rule.source_security_group_id, null)] : merge(_rule, {
            type                     = "ingress"
            source_security_group_id = source_security_group_id
          })
          if var.create && try(contains(keys(_rule), "source_security_group_id"), false)
        ],
        [
          for self in [try(_rule.self, null)] : merge(_rule, {
            type = "ingress"
            self = self
          })
          if var.create && try(contains(keys(_rule), "self"), false)
        ],
      ])
      ],
    ) : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule
  }

  dedicated_egress = {
    for rule in flatten([
      for _rule in var.dedicated_egress : flatten([
        [
          for cidr_block in try(_rule.cidr_blocks, []) : merge(_rule, {
            type        = "egress"
            cidr_blocks = [cidr_block]
          })
          if var.create && try(contains(keys(_rule), "cidr_blocks"), false)
        ],
        [
          for ipv6_cidr_block in try(_rule.ipv6_cidr_blocks, []) : merge(_rule, {
            type             = "egress"
            ipv6_cidr_blocks = [ipv6_cidr_block]
          })
          if var.create && try(contains(keys(_rule), "ipv6_cidr_block"), false)
        ],
        [
          for prefix_list_id in try(_rule.prefix_list_ids, []) : merge(_rule, {
            type            = "egress"
            prefix_list_ids = [prefix_list_id]
          })
          if var.create && try(contains(keys(_rule), "prefix_list_ids"), false)
        ],
        [
          for source_security_group_id in [try(_rule.source_security_group_id, null)] : merge(_rule, {
            type                     = "egress"
            source_security_group_id = source_security_group_id
          })
          if var.create && try(contains(keys(_rule), "source_security_group_id"), false)
        ],
        [
          for self in [try(_rule.self, null)] : merge(_rule, {
            type = "egress"
            self = self
          })
          if var.create && try(contains(keys(_rule), "self"), false)
        ],
      ])
      ],
    ) : lower(replace(replace(join("-", compact(flatten(values(rule)))), " ", "-"), "_", "-")) => rule
  }
}

resource "aws_security_group_rule" "dedicated_ingress" {
  for_each                 = local.dedicated_ingress
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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "dedicated_egress" {
  for_each                 = local.dedicated_egress
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

  lifecycle {
    create_before_destroy = true
  }
}
