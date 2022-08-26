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

output "data_aws_security_group_default_id" {
  description = "The ID of the security group data resource."
  value       = data.aws_security_group.default.id
}

output "pre_existing_sg_id" {
  description = "The pre-existing security group ID."
  value       = aws_security_group.pre_existing_sg.id
}
