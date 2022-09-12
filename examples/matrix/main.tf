module "security_group" {
  source = "../../"

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  computed_matrix_ingress = {
    rules = [
      { rule = "https-443-tcp" },
      { rule = "http-80-tcp" },
    ],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    ipv6_cidr_blocks         = []
    prefix_list_ids          = [aws_ec2_managed_prefix_list.other.id]
    source_security_group_id = aws_security_group.other.id
    self                     = true
  }

  computed_matrix_egress = {
    rules                    = [{ rule = "https-443-tcp" }],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    source_security_group_id = aws_security_group.other.id
  }

  tags = {
    "Name" = local.name
  }
}
