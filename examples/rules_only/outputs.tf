output "pre_existing_sg_id" {
  description = "The pre-existing security group ID."
  value       = aws_security_group.pre_existing_sg.id
}

output "managed_security_group_rule_keys" {
  description = "The managed security group rule keys."
  value       = module.security_group.managed_security_group_rule_keys
}

output "security_group_rule_keys" {
  description = "The security group rule keys."
  value       = module.security_group.security_group_rule_keys
}
