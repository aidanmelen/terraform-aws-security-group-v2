# Protocols (tcp, udp, icmp, all - are allowed keywords) or numbers (from https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml):
# All = -1, IPV4-ICMP = 1, TCP = 6, UDP = 17, IPV6-ICMP = 58
locals {
  common_rules = {
    # common rules with "from" are intended to be used with ingress module arguments
    all-all-self     = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true }
    https-tcp-public = { "to_port" = 443, "from_port" = 443, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
    http-tcp-public  = { "to_port" = 80, "from_port" = 80, "protocol" = "tcp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
    all-icmp-public  = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
    all-ping-public  = { "to_port" = 0, "from_port" = 0, "protocol" = "icmp", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }

    # common rules with "to" are intended to be used with egress module arguments
    all-all-self   = { "to_port" = 0, "from_port" = 0, "protocol" = "all", self = true }
    all-all-public = { "to_port" = 0, "from_port" = 0, "protocol" = "all", cidr_blocks = ["0.0.0.0/0"], ipv6_cidr_blocks = ["::/0"] }
  }

  common_rules_with_type_annotation = {
    # common rules with "from" are intended to be used with ingress module arguments
    all-all-from-self     = local.common_rules["all-all-self"]
    https-tcp-from-public = local.common_rules["https-tcp-public"]
    http-tcp-from-public  = local.common_rules["http-tcp-public"]
    all-icmp-from-public  = local.common_rules["all-icmp-public"]
    all-ping-from-public  = local.common_rules["all-ping-public"]

    # common rules with "to" are intended to be used with egress module arguments
    all-all-to-self   = local.common_rules["all-all-self"]
    all-all-to-public = local.common_rules["all-all-public"]
  }
}
