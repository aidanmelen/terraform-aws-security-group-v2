module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
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
    },
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    { rule = "https-from-public" },
    { rule = "http-from-public" },
    { rule = "all-from-self" }
  ]

  computed_ingress = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
    },
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    }
  ]

  egress = [
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
    },
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = "icmp"
      source_security_group_id = data.aws_security_group.default.id
    },
    { rule = "all-to-public" }
  ]

  computed_egress = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    },
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
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
