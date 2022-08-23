output "security_group_arn" {
  description = "The ARN of the security group"
  value       = try(aws_security_group.self[0].arn, null)
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = try(aws_security_group.self[0].id, null)
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = try(aws_security_group.self[0].vpc_id, null)
}

output "security_group_owner_id" {
  description = "The owner ID"
  value       = try(aws_security_group.self[0].owner_id, null)
}

output "security_group_name" {
  description = "The name of the security group"
  value       = try(aws_security_group.self[0].name, null)
}

output "security_group_description" {
  description = "The description of the security group"
  value       = try(aws_security_group.self[0].description, null)
}

output "managed_security_group_rule_ids" {
  description = "The managed security group rule IDs."
  value       = try([for rule in aws_security_group_rule.managed_rules : rule["id"]], null)
}

output "managed_security_group_rule_keys" {
  description = "The managed security group rule keys."
  value       = try(keys(aws_security_group_rule.managed_rules), null)
}

output "security_group_rule_ids" {
  description = "The security group rule IDs."
  value       = try([for rule in aws_security_group_rule.rules : rule["id"]], null)
}

output "security_group_rule_keys" {
  description = "The security group rule keys."
  value       = try(keys(aws_security_group_rule.rules), null)
}
