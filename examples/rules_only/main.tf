resource "aws_security_group" "pre_existing_sg" {
  name   = "${local.name}-pre-existing-sg"
  vpc_id = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-pre-existing-sg"
  }
}

module "security_group" {
  source = "../../"

  create_sg         = false
  security_group_id = aws_security_group.pre_existing_sg.id

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  managed_ingress_rules = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = data.aws_security_group.default.id
    }
  ]

  tags = {
    "Name" = local.name
  }
}
