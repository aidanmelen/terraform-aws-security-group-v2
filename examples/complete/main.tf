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
      from_port                = -1
      to_port                  = -1
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "-1"
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
      from_port                = -1
      to_port                  = -1
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    {
      from_port = -1
      to_port   = -1
      protocol  = "-1"
      self      = true
    }
  ]

  computed_ingress_rules = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  computed_egress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]

  computed_managed_ingress_rules = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  computed_managed_egress_rules = [
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]

  create_auto_group_ingress_all_from_self_rules         = true
  create_auto_group_egress_all_to_public_internet_rules = true

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
