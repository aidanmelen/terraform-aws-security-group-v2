###############################################################################
# Security Group
###############################################################################

output "security_group" {
  description = "The security group attributes."
  value = try(
    {
      arn                    = try(aws_security_group.self[0].arn, null)
      description            = try(aws_security_group.self[0].description, null)
      id                     = try(aws_security_group.self[0].id, null)
      name                   = try(aws_security_group.self[0].name, null)
      name_prefix            = try(aws_security_group.self[0].name_prefix, null)
      owner_id               = try(aws_security_group.self[0].owner_id, null)
      revoke_rules_on_delete = try(aws_security_group.self[0].revoke_rules_on_delete, null)
      tags                   = try(aws_security_group.self[0].tags, null)
      tags_all               = try(aws_security_group.self[0].tags_all, null)
      timeouts               = try(aws_security_group.self[0].timeouts, null)
      vpc_id                 = try(aws_security_group.self[0].vpc_id, null)
    },
    {
      arn                    = try(aws_security_group.self_with_name_prefix[0].arn, null)
      description            = try(aws_security_group.self_with_name_prefix[0].description, null)
      id                     = try(aws_security_group.self_with_name_prefix[0].id, null)
      name                   = try(aws_security_group.self_with_name_prefix[0].name, null)
      name_prefix            = try(aws_security_group.self_with_name_prefix[0].name_prefix, null)
      owner_id               = try(aws_security_group.self_with_name_prefix[0].owner_id, null)
      revoke_rules_on_delete = try(aws_security_group.self_with_name_prefix[0].revoke_rules_on_delete, null)
      tags                   = try(aws_security_group.self_with_name_prefix[0].tags, null)
      tags_all               = try(aws_security_group.self_with_name_prefix[0].tags_all, null)
      timeouts               = try(aws_security_group.self_with_name_prefix[0].timeouts, null)
      vpc_id                 = try(aws_security_group.self_with_name_prefix[0].vpc_id, null)
    },
    null
  )
}

###############################################################################
# Security Group Rules
###############################################################################

output "security_group_ingress_rules" {
  description = "The security group ingress rules."
  value = concat(
    try(values(aws_security_group_rule.ingress), []),
    try(values(aws_security_group_rule.matrix_ingress), []),
    try(aws_security_group_rule.computed_ingress, []),
    try(aws_security_group_rule.computed_matrix_ingress_with_cidr_blocks_and_prefix_list_ids, []),
    try(aws_security_group_rule.computed_matrix_ingress_with_source_security_group_id, []),
    try(aws_security_group_rule.computed_matrix_ingress_with_self, []),
  )
}

output "security_group_egress_rules" {
  description = "The security group egress rules."
  value = concat(
    try(values(aws_security_group_rule.egress), []),
    try(values(aws_security_group_rule.matrix_egress), []),
    try(aws_security_group_rule.computed_egress, []),
    try(aws_security_group_rule.computed_matrix_egress_with_cidr_blocks_and_prefix_list_ids, []),
    try(aws_security_group_rule.computed_matrix_egress_with_source_security_group_id, []),
    try(aws_security_group_rule.computed_matrix_egress_with_self, []),
  )
}

###############################################################################
# Rule Aliases
###############################################################################

output "rule_aliases" {
  description = "The module rule aliases."
  value       = local.rule_aliases
}

###############################################################################
# Debug
###############################################################################

output "debug" {
  description = "Debug information on local for_each loops."
  value       = local.debug
}
