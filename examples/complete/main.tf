module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [
    {
      rule        = "all-all"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      rule            = "ssh-tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    }
  ]

  ingress_rules = [
    {
      protocol                 = "icmp"
      from_port                = -1
      to_port                  = -1
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      protocol  = "-1"
      from_port = -1
      to_port   = -1
      self      = true
    }
  ]

  managed_egress_rules = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      rule            = "ssh-tcp"
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    }
  ]

  egress_rules = [
    {
      protocol                 = "icmp"
      from_port                = -1
      to_port                  = -1
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      protocol  = "-1"
      from_port = -1
      to_port   = -1
      self      = true
    }
  ]

  tags = {
    "Name" = local.name
  }
}

################################################################################
# Disabled creation
################################################################################

module "disabled_sg" {
  source = "../../"
  create = false
}
