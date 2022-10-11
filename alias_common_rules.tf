# Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
# All = 0, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
locals {
  common_rule_aliases_internal = {
    # common rules with "from" are intended to be used with ingress module arguments
    all-all-self         = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true, description = "All protocols self" }
    https-443-tcp-public = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTPS from public" }
    https-tcp-public     = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTPS from public" }
    https-public         = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTPS from public" }
    http-80-tcp-public   = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTP from public" }
    http-tcp-public      = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTP from public" }
    http-public          = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "HTTP from public" }
    all-icmp-public      = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV4 ICMP from public" }
    all-ping-public      = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV4 ICMP from public" }
    all-ipv6-icmp-public = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV6 ICMP from public" }
    all-ipv6-ping-public = { "to_port" = 0, "from_port" = 0, "protocol" = 58, cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All IPV6 ICMP from public" }

    # common rules with "to" are intended to be used with egress module arguments
    all-all-self   = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true, description = "All protocols to self" }
    all-all-public = { "to_port" = 0, "from_port" = 0, "protocol" = "all", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"], description = "All to public" }
  }

  common_rule_aliases_with_type_annotation_internal = {
    # common rules with "from" are intended to be used with ingress module arguments
    all-all-from-self         = local.common_rule_aliases_internal["all-all-self"]
    https-443-tcp-from-public = local.common_rule_aliases_internal["https-443-tcp-public"]
    https-tcp-from-public     = local.common_rule_aliases_internal["https-tcp-public"]
    https-from-public         = local.common_rule_aliases_internal["https-public"]
    http-80-tcp-from-public   = local.common_rule_aliases_internal["http-80-tcp-public"]
    http-tcp-from-public      = local.common_rule_aliases_internal["http-tcp-public"]
    http-from-public          = local.common_rule_aliases_internal["http-public"]
    all-icmp-from-public      = local.common_rule_aliases_internal["all-icmp-public"]
    all-ping-from-public      = local.common_rule_aliases_internal["all-ping-public"]

    # common rules with "to" are intended to be used with egress module arguments
    all-all-to-self   = local.common_rule_aliases_internal["all-all-self"]
    all-all-to-public = local.common_rule_aliases_internal["all-all-public"]
  }

  common_rule_aliases = merge(
    local.common_rule_aliases_internal,
    local.common_rule_aliases_with_type_annotation_internal
  )
}
