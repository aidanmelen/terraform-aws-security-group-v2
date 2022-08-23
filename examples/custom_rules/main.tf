module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = [
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      protocol         = "tcp"
      from_port        = 350
      to_port          = 450
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      protocol        = "tcp"
      from_port       = 22
      to_port         = 22
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
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

  egress_rules = [
    {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    },
    {
      protocol         = "tcp"
      from_port        = 350
      to_port          = 450
      ipv6_cidr_blocks = ["2001:db8::/64"]
    },
    {
      protocol        = "tcp"
      from_port       = 22
      to_port         = 22
      prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    },
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
