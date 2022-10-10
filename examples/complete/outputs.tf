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

################################################################################
# Disabled creation
################################################################################

output "disabled_sg_id" {
  description = "The disabled security group IDs."
  value       = try(module.disabled_sg[0].id, "I was not created")
}

###############################################################################
# Terratest
###############################################################################

output "terratest" {
  description = "Outputs used by Terratest."
  value = {
    "ingress_count"                        = try(length(module.security_group.security_group_ingress_rules), null)
    "egress_count"                         = try(length(module.security_group.security_group_egress_rules), null)
    "data_aws_security_group_default_id"   = data.aws_security_group.default.id,
    "data_aws_prefix_list_private_s3_id"   = data.aws_prefix_list.private_s3.id,
    "aws_security_group_other_id"          = aws_security_group.other.id,
    "aws_ec2_managed_prefix_list_other_id" = aws_ec2_managed_prefix_list.other.id,
  }
}
