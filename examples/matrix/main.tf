module "security_group" {
  source = "../../"

  name        = local.name
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule             = "https-443-tcp"
      cidr_blocks      = [data.aws_vpc.default.cidr_block]
      ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  egress = [
    { rule = "all-all-to-public" }
  ]

  tags = {
    "Name" = local.name
  }
}
