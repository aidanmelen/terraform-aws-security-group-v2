module "security_group" {
  source = "../../"

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  matrix_ingress = {
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

  matrix_egress = {
    rules                    = [{ rule = "https-443-tcp" }],
    cidr_blocks              = ["10.0.0.0/24", "10.0.1.0/24"]
    source_security_group_id = aws_security_group.other.id
  }

  tags = {
    "Name" = local.name
  }
}

module "additional_sg_matrix_ingress" {
  source = "../../"

  create_security_group = false
  security_group_id     = module.security_group.security_group.id

  matrix_ingress = {
    description = "Matix Ingress rules for PostgreSQL"
    rules = [
      {
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
      },
    ],
    cidr_blocks = ["10.0.0.0/24", "10.0.1.0/24"]
  }

  tags = {
    "Name" = local.name
  }
}
