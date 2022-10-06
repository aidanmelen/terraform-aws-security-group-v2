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
    # {
    #   rule             = "postgresql-tcp"
    #   ipv6_cidr_blocks = ["2001:db8::/64"]
    # },
    # {
    #   rule            = "ssh-tcp"
    #   prefix_list_ids = [data.aws_prefix_list.private_s3.id]
    # },
    # {
    #   from_port                = 0
    #   to_port                  = 0
    #   protocol                 = "icmp"
    #   source_security_group_id = data.aws_security_group.default.id
    #   description              = "customer rule example"
    # },
    # {
    #   rule        = "https-tcp-from-public"
    #   description = "common rule example"
    # },
    { rule = "http-tcp-from-public" },
    # { rule = "all-all-from-self" }
  ]

  # egress = [
  #   {
  #     rule        = "https-443-tcp"
  #     cidr_blocks = ["10.10.0.0/16", "10.20.0.0/24"]
  #     description = "managed rule example"
  #   },
  #   {
  #     rule             = "postgresql-tcp"
  #     ipv6_cidr_blocks = ["2001:db8::/64"]
  #   },
  #   {
  #     rule            = "ssh-tcp"
  #     prefix_list_ids = [data.aws_prefix_list.private_s3.id]
  #   },
  #   {
  #     from_port                = 0
  #     to_port                  = 0
  #     protocol                 = "icmp"
  #     source_security_group_id = data.aws_security_group.default.id
  #     description              = "customer rule example"
  #   },
  #   {
  #     rule        = "all-all-to-public"
  #     description = "common rule example"
  #   }
  # ]

  unpack = false
}
