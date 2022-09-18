#tfsec:ignore:aws-vpc-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "public_https_sg" {
  source = "../../"

  name        = "${local.name}-https"
  description = "${local.name}-https"
  vpc_id      = data.aws_vpc.default.id

  ingress = [{ rule = "https-tcp-from-public" }, { rule = "all-all-from-self" }]
  egress  = [{ rule = "all-all-to-public" }]

  tags = {
    "Name" = "${local.name}-https"
  }
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

  tags = {
    "Name" = "${local.name}-http"
  }
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "rule_type_override_sg" {
  source = "../../"

  name        = "${local.name}-rule-type-override"
  description = "${local.name}-rule-type-override"
  vpc_id      = data.aws_vpc.default.id

  # override the default type for the ingress module arguments
  ingress = [
    {
      # managed type (egress) for the common rule will take precedence over the module argument (ingress)
      rule = "all-all-to-public",
    },
    {
      # the type argument (egress) will take precedence over both the module argument and common rule type (ingress)
      rule = "all-all-from-self"
      type = "egress"
    }
  ]

  # egress rules will be created using the rules from above eventhough the egress module argument is empty
  egress = []

  tags = {
    "Name" = "${local.name}-rule-type-override"
  }
}
