###############################################################################
# Security Group
###############################################################################

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

###############################################################################
# Custom Security Group Rules
###############################################################################

output "ingress_rule_ids" {
  description = "The ingress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.rules : rule["id"] if rule["type"] == "ingress"], null)
}

output "ingress_rule_keys" {
  description = "The ingress security group rule keys."
  value       = try([for key, rule in aws_security_group_rule.rules : key if rule["type"] == "ingress"], null)
}

output "egress_rule_ids" {
  description = "The egress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.rules : rule["id"] if rule["type"] == "egress"], null)
}

output "egress_rule_keys" {
  description = "The egress security group rule keys."
  value       = try([for key, rule in aws_security_group_rule.rules : key if rule["type"] == "egress"], null)
}

###############################################################################
# Managed Security Group Rules
###############################################################################

output "managed_ingress_rule_ids" {
  description = "The managed ingress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.managed_rules : rule["id"] if rule["type"] == "ingress"], null)
}

output "managed_ingress_rule_keys" {
  description = "The managed ingress security group rule keys."
  value       = try([for key, rule in aws_security_group_rule.managed_rules : key if rule["type"] == "ingress"], null)
}

output "managed_egress_rule_ids" {
  description = "The managed egress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.managed_rules : rule["id"] if rule["type"] == "egress"], null)
}

output "managed_egress_rule_keys" {
  description = "The managed egress security group rule keys."
  value       = try([for key, rule in aws_security_group_rule.managed_rules : key if rule["type"] == "egress"], null)
}

###############################################################################
# Computed Security Group Rules
###############################################################################

output "computed_ingress_rule_ids" {
  description = "The computed ingress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.computed_ingress_rules : rule["id"] if rule["type"] == "ingress"], null)
}

output "computed_egress_rule_ids" {
  description = "The computed egress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.computed_egress_rules : rule["id"] if rule["type"] == "egress"], null)
}

###############################################################################
# Managed Computed Security Group Rules
###############################################################################

output "computed_managed_ingress_rule_ids" {
  description = "The computed managed ingress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.computed_managed_ingress_rules : rule["id"] if rule["type"] == "ingress"], null)
}

output "computed_managed_egress_rule_ids" {
  description = "The computed managed egress security group rule IDs."
  value       = try([for rule in aws_security_group_rule.computed_managed_egress_rules : rule["id"] if rule["type"] == "egress"], null)
}

###############################################################################
# Auto Group Rules
###############################################################################

output "auto_group_ingress_all_from_self_rule_ids" {
  description = "The auto group ingress all to self rule IDs."
  value       = try([for rule in aws_security_group_rule.auto_group_egress_all_to_public_internet_rules : rule["id"] if rule["type"] == "egress"], null)
}

output "auto_group_ingress_all_from_self_rule_keys" {
  description = "The auto group ingress all to self rule key."
  value       = try([for key, rule in aws_security_group_rule.auto_group_egress_all_to_public_internet_rules : key if rule["type"] == "egress"], null)
}

output "auto_group_egress_to_public_internet_rule_ids" {
  description = "The auto group egress all to public internet rule IDs."
  value       = try([for rule in aws_security_group_rule.auto_group_egress_all_to_public_internet_rules : rule["id"] if rule["type"] == "egress"], null)
}

output "auto_group_egress_all_to_public_internet_rule_keys" {
  description = "The auto group egress all to public internet rule keys."
  value       = try([for key, rule in aws_security_group_rule.auto_group_egress_all_to_public_internet_rules : key if rule["type"] == "egress"], null)
}
