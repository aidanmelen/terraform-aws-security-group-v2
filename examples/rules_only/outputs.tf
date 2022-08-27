###############################################################################
# Security Group
###############################################################################

output "security_group" {
  description = "The security group."
  value       = try(module.security_group, null)
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
