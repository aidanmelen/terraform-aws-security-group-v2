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

output "auto_group_ingress_all_from_self_rule_keys" {
  description = "The auto group ingress all to self rule key."
  value       = module.security_group.auto_group_ingress_all_from_self_rule_keys
}

output "auto_group_ingress_https_from_public_internet_rule_keys" {
  description = "The auto group ingress HTTPS from the public internet rule keys."
  value       = module.security_group.auto_group_ingress_https_from_public_internet_rule_keys
}

output "auto_group_ingress_http_from_public_internet_rule_keys" {
  description = "The auto group ingress HTTP from the public internet rule keys."
  value       = module.security_group.auto_group_ingress_http_from_public_internet_rule_keys
}

output "auto_group_egress_all_to_public_internet_rule_keys" {
  description = "The auto group egress all to public internet rule keys."
  value       = module.security_group.auto_group_egress_all_to_public_internet_rule_keys
}
################################################################################
# Disabled creation
################################################################################

output "disabled_sg_id" {
  description = "The disabled security group IDs."
  value       = try(module.disabled_sg[0].id, "I was not created")
}
