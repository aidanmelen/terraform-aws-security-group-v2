###############################################################################
# Security Group
###############################################################################

output "arn" {
  description = "The ARN of the security group."
  value       = try(module.security_group.security_group_arn, null)
}

output "id" {
  description = "The ID of the security group."
  value       = try(module.security_group.security_group_id, null)
}

###############################################################################
# Security Group Rules
###############################################################################

output "ingress" {
  description = "The security group ingress rules."
  value       = try(module.security_group.security_group_ingress_rules, null)
}

output "ingress_keys" {
  description = "The security group ingress rules keys."
  value       = try(keys(module.security_group.security_group_ingress_rules), null)
}

output "egress" {
  description = "The security group egress rules."
  value       = try(module.security_group.security_group_egress_rules, null)
}

output "egress_keys" {
  description = "The security group egress rules keys."
  value       = try(keys(module.security_group.security_group_egress_rules), null)
}
