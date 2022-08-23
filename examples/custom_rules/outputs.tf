output "managed_security_group_rule_keys" {
  description = "The managed security group rule keys."
  value       = module.security_group.managed_security_group_rule_keys
}

output "security_group_rule_keys" {
  description = "The security group rule keys."
  value       = module.security_group.security_group_rule_keys
}
