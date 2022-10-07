###############################################################################
# Security Group
###############################################################################

output "arn" {
  description = "The ARN of the security group."
  value       = try(module.security_group.security_group.arn, null)
}

output "id" {
  description = "The ID of the security group."
  value       = try(module.security_group.security_group.id, null)
}

###############################################################################
# Security Group Rules
###############################################################################

output "ingress" {
  description = "The security group ingress rules."
  value       = try(module.security_group.security_group_ingress_rules, null)
}

output "egress" {
  description = "The security group egress rules."
  value       = try(module.security_group.security_group_egress_rules, null)
}

###############################################################################
# Terratest
###############################################################################

output "terratest" {
  description = "The IDs of unknown aws resources to be used by Terratest."
  value = {
    "ingress_count"                      = try(length(module.security_group.security_group_ingress_rules), null)
    "egress_count"                       = try(length(module.security_group.security_group_egress_rules), null)
    "data_aws_security_group_default_id" = data.aws_security_group.default.id,
    "pre_existing_security_group_id"     = module.pre_existing.security_group.id,
  }
}
