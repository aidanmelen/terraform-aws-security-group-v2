module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = ["10.0.0.0/24"]
      description = "My Private Service"
    },
    { rule = "all-from-self" }
  ]

  egress = [
    { rule = "all-to-public" }
  ]

  tags = {
    "Name" = local.name
  }
}
