#tfsec:ignore:aws-vpc-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "public_https_sg" {
  source = "../../"

  name        = "${local.name}-https"
  description = "${local.name}-https"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "https-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "public_http_sg" {
  source = "../../"

  name        = "${local.name}-http"
  description = "${local.name}-http"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "http-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]
}
