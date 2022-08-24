module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [
    {
      rule        = "https-443-tcp"
      description = "My Service"
      cidr_blocks = ["10.0.0.0/24"]
    }
  ]

  create_auto_group_ingress_all_from_self_rules         = true
  create_auto_group_egress_all_to_public_internet_rules = true

  tags = {
    "Name" = local.name
  }
}
