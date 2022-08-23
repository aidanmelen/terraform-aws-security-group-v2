locals {
  self_sg_id = var.create && var.create_sg ? aws_security_group.self[0].id : var.security_group_id

  /*
  Custom security group rules are created with this terraform ID format:

  type-protocol-to_port-from_port-from|to-source

  for example:

  ingress-all-all-all-from-self
  ingress-icmp-all-all-from-sg-b551fece
  ingress-tcp-22-22-from-pl-68a54001
  ingress-tcp-443-443-from-10.10.0.0/16,10.20.0.0/24
  ingress-tcp-450-350-from-2001:db8::/64
  egress-all-all-all-to-self
  egress-icmp-all-all-to-sg-b551fece
  egress-tcp-22-22-to-pl-68a54001
  egress-tcp-443-443-to-10.10.0.0/16,10.20.0.0/24
  egress-tcp-450-350-to-2001:db8::/64
  */

  rules = merge(
    {
      for rule in var.ingress_rules : join("-", compact([
        "ingress",
        lookup(rule, "protocol", null) == "-1" ? "all" : lookup(rule, "protocol", null),
        lookup(rule, "to_port", null) == -1 ? "all" : lookup(rule, "to_port", null),
        lookup(rule, "from_port", null) == -1 ? "all" : lookup(rule, "from_port", null),
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
        lookup(rule, "protocol", null) == "-1" ? "all" : lookup(rule, "protocol", null),
        lookup(rule, "to_port", null) == -1 ? "all" : lookup(rule, "to_port", null),
        lookup(rule, "from_port", null) == -1 ? "all" : lookup(rule, "from_port", null),
        "to",
        join(",", lookup(rule, "cidr_blocks", [])),
        join(",", lookup(rule, "ipv6_cidr_blocks", [])),
        join(",", lookup(rule, "prefix_list_ids", [])),
        lookup(rule, "self", false) == true ? "self" : lookup(rule, "self", null),
        lookup(rule, "source_security_group_id", null)
      ])) => rule
    }
  )

  /*
  Managed security group rules are created with this terraform ID formats:

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
  rules_with_null_values         = { for k, v in local.rules : k => null }
  managed_rules_with_null_values = { for k, v in local.managed_rules : k => null }
}
