###############################################################################
# Security Group
###############################################################################

output "public_https_sg_id" {
  description = "The ID of the public HTTPS security group."
  value       = try(module.public_https_sg.security_group.id, null)
}

output "public_http_sg_id" {
  description = "The ID of the public HTTP security group."
  value       = try(module.public_http_sg.security_group.id, null)
}

output "rule_type_override_sg_id" {
  description = "The ID of the rule type override security group."
  value       = try(module.rule_type_override_sg.security_group.id, null)
}

###############################################################################
# Security Group Rules
###############################################################################

output "public_https_ingress" {
  description = "The public HTTPS security group ingress rules."
  value       = try(module.public_https_sg.security_group_ingress_rules, null)
}

output "public_https_egress" {
  description = "The public HTTPS security group egress rules."
  value       = try(module.public_https_sg.security_group_egress_rules, null)
}

output "public_http_ingress" {
  description = "The public HTTP security group ingress rules."
  value       = try(module.public_http_sg.security_group_ingress_rules, null)
}

output "public_http_egress" {
  description = "The public HTTP security group egress rules."
  value       = try(module.public_http_sg.security_group_egress_rules, null)
}

output "rule_type_override_ingress" {
  description = "The rule type override security group ingress rules."
  value       = try(module.rule_type_override_sg.security_group_ingress_rules, null)
}

output "rule_type_override_egress" {
  description = "The rule type override security group egress rules."
  value       = try(module.rule_type_override_sg.security_group_egress_rules, null)
}
