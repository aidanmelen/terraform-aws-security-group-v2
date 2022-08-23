module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [
    {
      rule        = "https-443-tcp"
      description = "My Service."
      cidr_blocks = ["10.0.0.0/24"]
    },
    {
      rule = "all-all"
      self = true
    }
  ]

  managed_egress_rules = [
    {
      rule        = "all-all"
      cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
    },
    {
      rule             = "all-all"
      ipv6_cidr_blocks = ["::/0"] #tfsec:ignore:aws-ec2-no-public-egress-sgr
    }
  ]

  tags = {
    "Name" = local.name
  }
}
