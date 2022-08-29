resource "aws_security_group" "pre_existing" {
  name        = "${local.name}-pre-existing"
  description = "${local.name}-pre-existing"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    "Name" = "${local.name}-pre-existing"
  }
}

module "security_group" {
  source = "../../"

  create_security_group = false
  security_group_id     = aws_security_group.pre_existing.id

  ingress = [{ rule = "https-tcp-from-public" }]
  egress  = [{ rule = "all-all-to-public" }]

  tags = {
    "Name" = local.name
  }
}
