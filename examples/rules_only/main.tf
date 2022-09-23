module "pre_existing" {
  source = "../../"

  description = "${local.name}-pre-existing"
  vpc_id      = data.aws_vpc.default.id
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "security_group" {
  source = "../../"

  create_security_group = false
  security_group_id     = module.pre_existing.security_group.id

  ingress = [{ rule = "https-tcp-from-public" }]
  egress  = [{ rule = "all-all-to-public" }]
}
