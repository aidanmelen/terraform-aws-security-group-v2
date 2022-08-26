module "public_https_sg" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  create_ingress_https_from_public_rules = true
  create_ingress_all_from_self_rule      = true
  create_egress_all_to_public_rules      = true

  tags = {
    "Name" = "${local.name}-http"
  }
}

module "public_http_sg" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  create_ingress_http_from_public_rules = true
  create_ingress_all_from_self_rule     = true
  create_egress_all_to_public_rules     = true

  tags = {
    "Name" = "${local.name}-http"
  }
}

module "ssh_sg" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  managed_ingress_rules = [{ rule = "ssh-tcp", cidr_blocks = ["10.0.0.0/24"] }]

  create_ingress_all_from_self_rule = true
  create_egress_all_to_public_rules = true

  tags = {
    "Name" = "${local.name}-ssh"
  }
}
