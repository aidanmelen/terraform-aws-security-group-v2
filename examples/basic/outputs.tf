###############################################################################
# Security Group
###############################################################################

output "arn" {
  description = "The ARN of the security group."
  value       = try(module.security_group.arn, null)
}

output "id" {
  description = "The ID of the security group."
  value       = try(module.security_group.id, null)
}

###############################################################################
# Rules
###############################################################################

output "ingress" {
  description = "The security group ingress rules."
  value       = try(module.security_group.ingress, null)
}

output "ingress_keys" {
  description = "The security group ingress rules keys."
  value       = try(keys(module.security_group.ingress), null)
}

output "egress" {
  description = "The security group egress rules."
  value       = try(module.security_group.egress, null)
}

output "egress_keys" {
  description = "The security group egress rules keys."
  value       = try(keys(module.security_group.egress), null)
}
