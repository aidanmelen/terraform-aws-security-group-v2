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
  description = "Outputs used by Terratest."
  value = {
    "ingress_count"                        = try(length(module.security_group.security_group_ingress_rules), null)
    "egress_count"                         = try(length(module.security_group.security_group_egress_rules), null)
    "aws_security_group_other_id"          = aws_security_group.other.id,
    "aws_ec2_managed_prefix_list_other_id" = aws_ec2_managed_prefix_list.other.id,
  }
}
