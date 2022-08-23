###############################################################################
# Ingress Rules
###############################################################################

output "ingress_rule_keys" {
  description = "The ingress security group rule keys."
  value       = module.security_group.ingress_rule_keys
}

output "managed_ingress_rule_keys" {
  description = "The managed ingress security group rule keys."
  value       = module.security_group.managed_ingress_rule_keys
}

###############################################################################
# Egress Rules
###############################################################################

output "managed_egress_rule_keys" {
  description = "The managed egress security group rule keys."
  value       = module.security_group.managed_egress_rule_keys
}

output "egress_rule_keys" {
  description = "The egress security group rule keys."
  value       = module.security_group.egress_rule_keys
}
