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
      rule        = "https-tcp-from-public"
      description = "unpack common rule"
    },
  ]

  unpack = true
}
