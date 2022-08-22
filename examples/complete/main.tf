module "managed_rules_sg" {
  source = "../../"

  name        = "example-with-managed-rules"
  description = "terraform-aws-security-group"
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = {
    "HTTPS from subnets" = {
      rule        = "all-all"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    }
    "PostgreSQL from subnet (ipv6)" = {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    }
    "SSH from from prefix lists" = {
      rule            = "ssh-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.example.id]
    }
    "All Pings from ${data.aws_security_group.default.name}" = {
      rule                     = "all-icmp"
      source_security_group_id = data.aws_security_group.default.id
    }
    "All from self" = {
      rule = "all-all"
      self = true
    }
  }

  managed_egress_rules = {
    "HTTPS to subnet" = {
      rule        = "https-443-tcp"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    }
    "PostgreSQL to subnet (ipv6)" = {
      rule             = "postgresql-tcp"
      ipv6_cidr_blocks = ["2001:db8::/64"]
    }
    "SSH to prefix lists" = {
      rule            = "ssh-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.example.id]
    }
    "All Pings to ${data.aws_security_group.default.name}" = {
      rule                     = "all-icmp"
      source_security_group_id = data.aws_security_group.default.id
    }
    "All to self" = {
      rule = "all-all"
      self = true
    }
  }

  tags = {
    "Name" = "example-with-managed-rules"
  }
}

module "custom_rules_sg" {
  source = "../../"

  name        = "example-with-custom-rules"
  description = "terraform-aws-security-group"
  vpc_id      = data.aws_vpc.default.id

  ingress_rules = {
    "HTTPS from subnets" = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    }
    "Service ports from subnet (ipv6)" = {
      protocol         = "tcp"
      from_port        = 350
      to_port          = 450
      ipv6_cidr_blocks = ["2001:db8::/64"]
    }

    "SSH from prefix lists" = {
      protocol        = "tcp"
      from_port       = 22
      to_port         = 22
      prefix_list_ids = [aws_ec2_managed_prefix_list.example.id]
    }
    "All Pings from ${data.aws_security_group.default.name}" = {
      protocol                 = "icmp"
      from_port                = -1
      to_port                  = -1
      source_security_group_id = data.aws_security_group.default.id
    }
    "All from self" = {
      protocol  = "-1"
      from_port = -1
      to_port   = -1
      self      = true
    }
  }

  egress_rules = {
    "HTTPS to subnet" = {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
    }
    "Service ports to subnet (ipv6)" = {
      protocol         = "tcp"
      from_port        = 350
      to_port          = 450
      ipv6_cidr_blocks = ["2001:db8::/64"]
    }

    "SSH to prefix lists" = {
      protocol        = "tcp"
      from_port       = 22
      to_port         = 22
      prefix_list_ids = [aws_ec2_managed_prefix_list.example.id]
    }
    "All Pings to ${data.aws_security_group.default.name}" = {
      protocol                 = "icmp"
      from_port                = -1
      to_port                  = -1
      source_security_group_id = data.aws_security_group.default.id
    }
    "All to self" = {
      protocol  = "-1"
      from_port = -1
      to_port   = -1
      self      = true
    }
  }

  tags = {
    "Name" = "example-with-custom-rules"
  }
}

###############################################################################
# Only Security Group Rules
###############################################################################
module "only_rules" {
  source = "../../"

  create_sg         = false
  security_group_id = module.managed_rules_sg.security_group_id

  name        = "example-with-managed-rules"
  description = "terraform-aws-security-group"
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = {
    "HTTP from subnets" = {
      rule                     = "http-80-tcp"
      source_security_group_id = data.aws_security_group.default.id
    }
  }
}