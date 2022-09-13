###############################################################################
# Security Group
###############################################################################

output "security_group" {
  description = "The security group attributes."
  value       = try(aws_security_group.self[0], null)
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
