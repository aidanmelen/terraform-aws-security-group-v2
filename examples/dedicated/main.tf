#tfsec:ignore:aws-ec2-no-public-ingress-sgr
#tfsec:ignore:aws-ec2-no-public-egress-sgr
module "security_group" {
  source = "../../"

  name        = local.name
  description = local.name
  vpc_id      = data.aws_vpc.default.id

  ingress = [
    {
      rule                     = "https-tcp"
      cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
      ipv6_cidr_blocks         = []
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "matrix rules default description"
      dedicated                = true
    }
  ]

  egress = [
    {
      rule                     = "https-tcp"
      cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
      ipv6_cidr_blocks         = []
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "matrix rules default description"
      dedicated                = true
    }
  ]
}
