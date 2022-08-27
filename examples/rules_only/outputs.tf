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

output "egress" {
  description = "The security group egress rules."
  value       = try(module.security_group.security_group_egress_rules, null)
}

###############################################################################
# Terratest
###############################################################################

output "terratest" {
  description = "The IDs of uknown aws resource to be used by Terratest."
  value = {
    "data_aws_security_group_default_id" = data.aws_security_group.default.id,
    "aws_security_group_pre_existing_id" = aws_security_group.pre_existing.id,
  }
}
