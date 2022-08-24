locals {
  /*
  Managed security group rules are created with this terraform resource ID format:

  type-rule-from|to-source

  for example:

  ingress-all-all-from-10.10.0.0/16,10.20.0.0/24
  ingress-all-all-from-self
  ingress-all-icmp-from-sg-b551fece
  ingress-postgresql-tcp-from-2001:db8::/64
  ingress-ssh-tcp-from-pl-68a54001
  egress-all-all-to-self
  egress-all-icmp-to-sg-b551fece
  egress-https-443-tcp-to-10.10.0.0/16,10.20.0.0/24
  egress-postgresql-tcp-to-2001:db8::/64
  egress-ssh-tcp-to-pl-68a54001
  */

  managed_rules = merge(
    {
      for rule in var.managed_ingress_rules : join("-", compact([
        "ingress",
        lookup(rule, "rule", "_"),
        "from",
        join(",", lookup(rule, "cidr_blocks", [])),
        join(",", lookup(rule, "ipv6_cidr_blocks", [])),
        join(",", lookup(rule, "prefix_list_ids", [])),
        lookup(rule, "self", false) == true ? "self" : lookup(rule, "self", null),
        lookup(rule, "source_security_group_id", null)
      ])) => rule
    },
    {
      for rule in var.managed_egress_rules : join("-", compact([
        "egress",
        lookup(rule, "rule", "_"),
        "to",
        join(",", lookup(rule, "cidr_blocks", [])),
        join(",", lookup(rule, "ipv6_cidr_blocks", [])),
        join(",", lookup(rule, "prefix_list_ids", [])),
        lookup(rule, "self", false) == true ? "self" : lookup(rule, "self", null),
        lookup(rule, "source_security_group_id", null)
      ])) => rule
    }
  )

  # The true and false result expressions must have consistent types.
  # So we create maps with the same keys but with null values to satisfy this constraint.
  managed_rules_with_null_values = { for k, v in local.managed_rules : k => null }
}

###############################################################################
# Managed Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "managed_rules" {
  for_each = var.create ? local.managed_rules : local.managed_rules_with_null_values

  type              = split("-", each.key)[0]
  security_group_id = local.self_sg_id
  description       = lookup(each.value, "description", each.key)

  from_port = local.managed_rule_definitions[each.value["rule"]]["from_port"]
  to_port   = local.managed_rule_definitions[each.value["rule"]]["to_port"]
  protocol  = local.managed_rule_definitions[each.value["rule"]]["protocol"]

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}
