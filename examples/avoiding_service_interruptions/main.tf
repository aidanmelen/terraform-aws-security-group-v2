module "consideration_1" {
  source = "../../"

  name        = join("-", [local.name, 1])
  vpc_id      = data.aws_vpc.default.id
  description = "Declare the key argument for rules to use CBD."

  ingress = [
    {
      key         = "my-key"
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
      # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  matrix_ingress = {
    rules = [
      {
        key  = "my-key"
        rule = "http-80-tcp"
      }
    ]
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
  }
}

module "consideration_2" {
  source = "../../"

  name        = join("-", [local.name, 2])
  vpc_id      = data.aws_vpc.default.id
  description = "In order to guarantee CRB with dynamic keys, it is best to add the new rule in one terraform run and remove the old rule in a second run."

  ingress = [
    # destroy the ipv4 rule after the ipv6 rule is applied
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    },
    # {
    #   rule             = "https-443-tcp"
    #   ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    # }
  ]
}

module "consideration_3" {
  source = "../../"

  name_prefix = join("-", [local.name, 3])
  vpc_id      = data.aws_vpc.default.id
  description = "Avoid computed rules by passing known values. Unknown values must be computed using count which may cause undesirable rule churn when updates occur."

  computed_ingress = [
    # commenting out the first rule will cause churn and
    # result in a service interrupt for the rule using the prefix_list_ids
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    },
    # commenting out the second rule will not cause churn
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]
}


module "consideration_4" {
  source = "../../"

  name   = join("-", [local.name, 4])
  vpc_id = data.aws_vpc.default.id

  ingress = [
    # removing/updating IPV4 rule will not effect the IPV6 rule
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    },
    {
      rule             = "https-443-tcp"
      ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]
}

module "consideration_5" {
  source = "../../"

  name_prefix = join("-", [local.name, 5, "blue"])
  # Force a SG level CBD with a name change
  # name_prefix = join("-", [local.name, 5, "green"])
  vpc_id      = data.aws_vpc.default.id
  description = "Use the name_prefix argument when the SG ID does not need to be preserved."

  computed_ingress = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
      # prefix_list_ids        = [aws_ec2_managed_prefix_list.other.id]
    }
  ]
}
