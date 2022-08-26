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


###############################################################################
# Computed Resource IDs
###############################################################################

output "aws_security_group_other_id" {
  description = "The ID of the computed security group."
  value       = aws_security_group.other.id
}

output "aws_ec2_managed_prefix_list_other_id" {
  description = "The ID of the computed prefix list."
  value       = aws_ec2_managed_prefix_list.other.id
}
