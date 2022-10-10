output "rules" {
  description = "The unpacked security group rules"
  value       = module.unpack.rules
}

###############################################################################
# Terratest
###############################################################################

output "terratest" {
  description = "Outputs used by Terratest."
  value = {
    "rule_count"                         = try(length(module.unpack.rules), null)
    "data_aws_security_group_default_id" = data.aws_security_group.default.id,
    "data_aws_prefix_list_private_s3_id" = data.aws_prefix_list.private_s3.id,
  }
}
