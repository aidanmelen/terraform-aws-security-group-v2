locals {
  /*
  Custom security group rules are created with this terraform resource ID format:

  type-protocol-to_port-from_port-from|to-source

  for example:

  ingress-22-22-tcp-from-pl-68a54001
  ingress-443-443-tcp-from-10.10.0.0/16,10.20.0.0/24
  ingress-450-350-tcp-from-2001:db8::/64
  ingress-all-all-all-from-self
  ingress-all-all-icmp-from-sg-b551fece
  egress-22-22-tcp-to-pl-68a54001
  egress-443-443-tcp-to-10.10.0.0/16,10.20.0.0/24
  egress-450-350-tcp-to-2001:db8::/64
  egress-all-all-all-to-self
  egress-all-all-icmp-to-sg-b551fece
  */

  rules = merge(
    {
      for rule in var.ingress_rules : join("-", compact([
        "ingress",
        lookup(rule, "to_port", null) == -1 ? "all" : lookup(rule, "to_port", null),
        lookup(rule, "from_port", null) == -1 ? "all" : lookup(rule, "from_port", null),
        lookup(rule, "protocol", null) == "-1" ? "all" : lookup(rule, "protocol", null),
        "from",
        join(",", lookup(rule, "cidr_blocks", [])),
        join(",", lookup(rule, "ipv6_cidr_blocks", [])),
        join(",", lookup(rule, "prefix_list_ids", [])),
        lookup(rule, "self", false) == true ? "self" : lookup(rule, "self", null),
        lookup(rule, "source_security_group_id", null)
      ])) => rule
    },
    {
      for rule in var.egress_rules : join("-", compact([
        "egress",
        lookup(rule, "to_port", null) == -1 ? "all" : lookup(rule, "to_port", null),
        lookup(rule, "from_port", null) == -1 ? "all" : lookup(rule, "from_port", null),
        lookup(rule, "protocol", null) == "-1" ? "all" : lookup(rule, "protocol", null),
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
  rules_with_null_values = { for k, v in local.rules : k => null }
}

###############################################################################
# Custom Security Group Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "rules" {
  for_each = var.create ? local.rules : local.rules_with_null_values

  type              = split("-", each.key)[0]
  security_group_id = local.self_sg_id
  description       = lookup(each.value, "description", each.key)

  from_port = each.value["from_port"]
  to_port   = each.value["to_port"]
  protocol  = each.value["protocol"]

  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}
