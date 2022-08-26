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

output "data_aws_prefix_list_private_s3_id" {
  description = "The ID of the prefix list data resource."
  value       = data.aws_prefix_list.private_s3.id
}

output "aws_security_group_other_id" {
  description = "The ID of the computed security group."
  value       = aws_security_group.other.id
}

output "aws_ec2_managed_prefix_list_other_id" {
  description = "The ID of the computed prefix list."
  value       = aws_ec2_managed_prefix_list.other.id
}


################################################################################
# Disabled creation
################################################################################

output "disabled_sg_id" {
  description = "The disabled security group IDs."
  value       = try(module.disabled_sg[0].id, "I was not created")
}
