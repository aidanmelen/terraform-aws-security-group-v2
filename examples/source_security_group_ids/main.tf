module "security_group" {
  source = "../../"

  name   = local.name
  vpc_id = data.aws_vpc.default.id

  # required for source_security_group_ids
  unpack = true

  ingress = [
    {
      rule                      = "https-443-tcp"
      source_security_group_ids = [data.aws_security_group.default.id]
    },
  ]
}

module "security_group_matrix" {
  source = "../../"

  name   = "${local.name}-matrix"
  vpc_id = data.aws_vpc.default.id

  # required for source_security_group_ids
  unpack = true

  matrix_ingress = {
    rules                     = [{ rule = "https-443-tcp" }],
    source_security_group_ids = [data.aws_security_group.default.id]
  }
}
