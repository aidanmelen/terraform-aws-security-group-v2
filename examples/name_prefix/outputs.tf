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
    "data_aws_vpc_default_cidr_block"      = data.aws_vpc.default.cidr_block
    "data_aws_vpc_default_ipv6_cidr_block" = data.aws_vpc.default.ipv6_cidr_block
  }
}
