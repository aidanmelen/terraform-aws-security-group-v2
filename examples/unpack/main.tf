#tfsec:ignore:aws-ec2-no-public-ingress-sgr
module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      from_port                = "22"
      to_port                  = "22"
      protocol                 = "TCP"
      cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
      ipv6_cidr_blocks         = ["2001:db8::/64"]
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "unpack customer rules"
    },
    {
      rule                     = "postgresql-tcp"
      cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
      ipv6_cidr_blocks         = ["2001:db8::/64"]
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "unpack managed rules"
    },
    {
      rule        = "https-from-public"
      description = "unpack common rule"
    },
  ]

  matrix_ingress = {
    rules = [
      {
        from_port   = 25
        to_port     = 25
        protocol    = "tcp"
        description = "unpack customer rule"
      },
      {
        rule        = "mysql-tcp"
        description = "unpack managed rule"
      },
      {
        rule        = "http-from-public"
        description = "unpack common rule"
      },
    ],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    ipv6_cidr_blocks         = []
    prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
    source_security_group_id = data.aws_security_group.default.id
    self                     = true
  }

  # ommitted for the sake of not creating a whole lot of example egress rules
  # egress = [
  #   {
  #     from_port                = "22"
  #     to_port                  = "22"
  #     protocol                 = "TCP"
  #     cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
  #     ipv6_cidr_blocks         = ["2001:db8::/64"]
  #     prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
  #     source_security_group_id = data.aws_security_group.default.id
  #     self                     = true
  #     description              = "unpack customer rules"
  #   },
  #   {
  #     rule                     = "postgresql-tcp"
  #     cidr_blocks              = ["10.10.0.0/16", "10.20.0.0/24"]
  #     ipv6_cidr_blocks         = ["2001:db8::/64"]
  #     prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
  #     source_security_group_id = data.aws_security_group.default.id
  #     self                     = true
  #     description              = "unpack managed rules"
  #   },
  #   {
  #     rule        = "https-from-public"
  #     description = "unpack common rule"
  #   },
  # ]

  # matrix_egress = {
  #   rules = [
  #     {
  #       from_port   = 25
  #       to_port     = 25
  #       protocol    = "tcp"
  #       description = "unpack customer rule"
  #     },
  #     {
  #       rule        = "mysql-tcp"
  #       description = "unpack managed rule"
  #     },
  #     {
  #       rule        = "http-from-public"
  #       description = "unpack common rule"
  #     },
  #   ],
  #   cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
  #   ipv6_cidr_blocks         = []
  #   prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
  #   source_security_group_id = data.aws_security_group.default.id
  #   self                     = true
  # }

  unpack = true
}
