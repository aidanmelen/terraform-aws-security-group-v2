output "pre_existing_sg_id" {
  description = "The pre-existing security group ID."
  value       = aws_security_group.pre_existing_sg.id
}

###############################################################################
# Custom Security Group Rules
###############################################################################

output "ingress_rule_keys" {
  description = "The ingress security group rule keys."
  value       = module.security_group.ingress_rule_keys
}
output "egress_rule_keys" {
  description = "The egress security group rule keys."
  value       = module.security_group.egress_rule_keys
}

###############################################################################
# Managed Security Group Rules
###############################################################################

output "managed_ingress_rule_keys" {
  description = "The managed ingress security group rule keys."
  value       = module.security_group.managed_ingress_rule_keys
}
output "managed_egress_rule_keys" {
  description = "The managed egress security group rule keys."
  value       = module.security_group.managed_egress_rule_keys
}

###############################################################################
# Computed Security Group Rules
###############################################################################

output "computed_ingress_rule_ids" {
  description = "The computed ingress security group rule IDs."
  value       = module.security_group.computed_ingress_rule_ids
}

output "computed_egress_rule_ids" {
  description = "The computed egress security group rule IDs."
  value       = module.security_group.computed_egress_rule_ids
}

###############################################################################
# Managed Computed Security Group Rules
###############################################################################

output "computed_managed_ingress_rule_ids" {
  description = "The computed managed ingress security group rule IDs."
  value       = module.security_group.computed_managed_ingress_rule_ids
}

output "computed_managed_egress_rule_ids" {
  description = "The computed managed egress security group rule IDs."
  value       = module.security_group.computed_managed_egress_rule_ids
}


###############################################################################
# Auto Group Rules
###############################################################################

output "auto_group_ingress_all_from_self_rule_ids" {
  description = "The auto group ingress all to self rule IDs."
  value       = module.security_group.auto_group_ingress_all_from_self_rule_ids
}

output "auto_group_ingress_all_from_self_rule_keys" {
  description = "The auto group ingress all to self rule keys."
  value       = module.security_group.auto_group_ingress_all_from_self_rule_keys
}

output "auto_group_egress_to_public_internet_rule_ids" {
  description = "The auto group egress all to public internet rule IDs."
  value       = module.security_group.auto_group_egress_to_public_internet_rule_ids
}

output "auto_group_egress_all_to_public_internet_rule_keys" {
  description = "The auto group egress all to public internet rule keys."
  value       = module.security_group.auto_group_egress_all_to_public_internet_rule_keys
}
