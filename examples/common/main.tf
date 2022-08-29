module "public_https_sg" {
  source = "../../"

  name        = "${local.name}-https"
  description = "${local.name}-https"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "https-from-public" }, { rule = "all-from-self" }]
  egress  = [{ rule = "all-to-public" }]

  tags = {
    "Name" = "${local.name}-https"
  }
}

module "public_http_sg" {
  source = "../../"

  name        = "${local.name}-http"
  description = "${local.name}-http"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "http-from-public" }, { rule = "all-from-self" }, { rule = "asdasd" }]
  egress  = [{ rule = "all-to-public" }]

  tags = {
    "Name" = "${local.name}-http"
  }
}

module "ssh_sg" {
  source = "../../"

  name        = "${local.name}-ssh"
  description = "${local.name}-ssh"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "ssh-tcp", cidr_blocks = ["10.0.0.0/24"] }, { rule = "all-from-self" }]
  egress  = [{ rule = "all-to-public" }]

  tags = {
    "Name" = "${local.name}-ssh"
  }
}
