###############################################################################
# Resources That Must Use Computed Security Group Rules
###############################################################################

resource "aws_security_group" "other" {
  name        = "${local.name}-other"
  description = "${local.name}-other"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-other"
  }
}

resource "aws_ec2_managed_prefix_list" "other" {
  name           = "${local.name}-other"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = data.aws_vpc.default.cidr_block
    description = "Primary"
  }
}

###############################################################################
# Security Group
###############################################################################

module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

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

  matrix_ingress = {
    rules = [
      { rule = "postgresql-tcp" },
      {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        description = "customer rule example"
      }
    ],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    ipv6_cidr_blocks         = []
    prefix_list_ids          = [aws_ec2_managed_prefix_list.other.id]
    source_security_group_id = aws_security_group.other.id
    self                     = true
    description              = "computed matrix default rule example"
  }

  computed_matrix_egress = {
    rules                    = [{ rule = "postgresql-tcp" }],
    source_security_group_id = aws_security_group.other.id
  }

  tags = {
    "Name" = local.name
  }
}
