locals {
  /*
  Managed security group rules will have the following terraform resource ID format:

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
        rule["rule"],
        "from",
        try(join(",", rule["cidr_blocks"]), ""),
        try(join(",", rule["ipv6_cidr_blocks"]), ""),
        try(join(",", rule["prefix_list_ids"]), ""),
        lookup(rule, "self", false) == true ? "self" : lookup(rule, "self", null),
        lookup(rule, "source_security_group_id", null)
      ])) => rule
    },
    {
      for rule in var.managed_egress_rules : join("-", compact([
        "egress",
        try(rule["rule"], "_"),
        "to",
        try(join(",", rule["cidr_blocks"]), ""),
        try(join(",", rule["ipv6_cidr_blocks"]), ""),
        try(join(",", rule["prefix_list_ids"]), ""),
        lookup(rule, "self", false) == true ? "self" : lookup(rule, "self", null),
        lookup(rule, "source_security_group_id", null)
      ])) => rule
    }
  )

  # https://github.com/hashicorp/terraform/issues/28751
  managed_rules_false_expr = { for k, v in local.managed_rules : k => null }
}

###############################################################################
# Managed Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "managed_rules" {
  for_each = var.create ? local.managed_rules : local.managed_rules_false_expr

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
