module "security_group" {
  source = "../../"

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  matrix_ingress = {
    rules = [
      { rule = "https-443-tcp" },
      {
        key         = "my-rule"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        description = "customer rule example with create before destroy lifecycle"
      }
    ],
    cidr_blocks              = ["10.0.0.0/24"]
    ipv6_cidr_blocks         = []
    prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
    source_security_group_id = data.aws_security_group.default.id
    self                     = true
    description              = "matrix rules default description"
  }

  matrix_egress = {
    rules                    = [{ rule = "https-443-tcp" }],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    source_security_group_id = data.aws_security_group.default.id
  }
}
