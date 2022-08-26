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
# Security Group Rules
###############################################################################

output "security_group_ingress_rules" {
  description = "The security group ingress rules."
  value = merge(
    {
      for k, rule in merge(
        aws_security_group_rule.rules,
        aws_security_group_rule.managed_rules,
        local.computed_rules,
        local.computed_managed_rules,
      ) : k => rule if rule["type"] == "ingress"
    },
    aws_security_group_rule.ingress_all_from_self_rule,
    aws_security_group_rule.ingress_https_from_public_rules,
    aws_security_group_rule.ingress_http_from_public_rules,
  )
}

output "security_group_egress_rules" {
  description = "The security group egress rules."
  value = merge(
    {
      for k, rule in merge(
        aws_security_group_rule.rules,
        aws_security_group_rule.managed_rules,
        local.computed_rules,
        local.computed_managed_rules,
      ) : k => rule if rule["type"] == "egress"
    },
    aws_security_group_rule.egress_all_to_public_rules,
  )
}
