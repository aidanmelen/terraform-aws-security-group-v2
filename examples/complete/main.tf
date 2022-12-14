#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule        = "all-all"
      cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
      description = "managed rule example"
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
      description              = "customer rule example"
    },
    {
      rule        = "https-tcp-from-public"
      description = "common rule example"
    },
    { rule = "http-tcp-from-public" },
    { rule = "all-all-from-self" }
  ]

  computed_ingress = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = aws_security_group.other.id
      description              = "This rule must be computed because it is created in the same terraform run as this module and is unknown at plan time."
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
      description = "managed rule example"
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
      description              = "customer rule example"
    },
    {
      rule        = "all-all-to-public"
      description = "common rule example"
    }
  ]

  computed_egress = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
      description     = "computed (customer) rule example"
    },
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
      description     = "computed (managed) rule example"
    }
  ]

  unpack = false

  tags = {
    "Name" = local.name
  }
}

################################################################################
# Export Rule Aliases
################################################################################

resource "aws_security_group" "example" {
  name        = "${local.name}-export-rule-alises"
  description = "Security group rule with exported module rule aliases."
  vpc_id      = data.aws_vpc.default.id
}

resource "aws_security_group_rule" "example" {
  type              = "ingress"
  description       = module.security_group.rule_aliases.https-443-tcp.description
  from_port         = module.security_group.rule_aliases.https-443-tcp.from_port
  to_port           = module.security_group.rule_aliases.https-443-tcp.to_port
  protocol          = module.security_group.rule_aliases.https-443-tcp.protocol
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = aws_security_group.example.id
}

################################################################################
# Disabled creation
################################################################################

module "disabled_sg" {
  source = "../../"
  create = false
}
