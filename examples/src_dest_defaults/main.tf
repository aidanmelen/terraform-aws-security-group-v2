module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  default_cidr_blocks      = ["10.10.0.0/24", "10.20.0.0/24"]
  default_ipv6_cidr_blocks = ["fc00::/116"]
  default_prefix_list_ids  = [data.aws_prefix_list.private_s3]

  ingress = [
    {
      rule             = "https-443-tcp"
      cidr_blocks      = ["10.0.0.0/24"]
      ipv6_cidr_blocks = ["fc00::/116"] # only one rule will be created
      prefix_list_ids  = []             # the defaults will be added because the value is not null
      description      = "Open ingress HTTPS from 10.0.0.0/24, 10.10.0.0/24, 10.20.0.0/24 and fc00::/116"
    }
  ]

  egress = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = ["10.30.0.0/24"]
      description = "Open egress HTTPS to 10.10.0.0/24, 10.20.0.0/24 and 10.30.0.0/24"

      # the defaults will be ignored when the value is commented out or null
      # ipv6_cidr_blocks = null
    }
  ]

  tags = {
    "Name" = local.name
  }
}
