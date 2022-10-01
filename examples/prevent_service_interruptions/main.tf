################################################################################
# Consideration 1
################################################################################

module "consideration_1" {
  source = "../../"

  name        = join("-", [local.name, 1])
  vpc_id      = data.aws_vpc.default.id
  description = "Rules with dynamic keys will use DBC lifecycle management"

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

################################################################################
# Consideration 2
################################################################################

module "consideration_2" {
  source = "../../"

  name        = join("-", [local.name, 2])
  vpc_id      = data.aws_vpc.default.id
  description = "Rules with user managed keys will use CBD lifecycle management"

  ingress = [
    {
      #   key         = "my-key"
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block, "10.0.0.0/24"]
      # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  matrix_ingress = {
    rules = [
      {
        # key  = "my-key"
        rule = "http-80-tcp"
      }
    ]
    cidr_blocks = [data.aws_vpc.default.cidr_block, "10.0.0.0/24"]
    # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
  }
}

################################################################################
# Consideration 3
################################################################################

module "consideration_3" {
  source = "../../"

  name        = join("-", [local.name, 3])
  vpc_id      = data.aws_vpc.default.id
  description = "Avoid rules with multiple sources/destinations"

  ingress = [
    # removing/updating IPV4 rule will not effect the IPV6 rule and vica versa
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    },
    # removing/updating IPV6 rule will not cause AWS API duplication errors
    {
      key              = "my-rule"
      rule             = "https-443-tcp"
      ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  # matrix rules will create a rule for each source/destination
  matrix_ingress = {
    rules = [
      {
        key  = "my-key"
        rule = "http-80-tcp"
      }
    ]
    cidr_blocks      = [data.aws_vpc.default.cidr_block]
    ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
  }
}

################################################################################
# Consideration 4
################################################################################

module "consideration_4" {
  source = "../../"

  name_prefix = join("-", [local.name, 4])
  vpc_id      = data.aws_vpc.default.id
  description = "Avoid computed rules by passing known values. Unknown values must be computed using count which may cause undesirable rule churn when updates occur"

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

################################################################################
# Consideration 5
################################################################################

module "consideration_5" {
  source = "../../"

  name_prefix = join("-", [local.name, 5, "blue"])
  # Force a SG level CBD with a name change
  # name_prefix = join("-", [local.name, 5, "green"])
  vpc_id      = data.aws_vpc.default.id
  description = "Use the name_prefix argument when the SG ID does not need to be preserved"

  ingress = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
      # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]
}

# the ENI will updated with the new SG ID before the old SG is destroyed
# thus preventing a service interruption
resource "aws_network_interface" "consideration_5" {
  subnet_id       = data.aws_subnet.default.id
  private_ips     = [cidrhost(data.aws_subnet.default.cidr_block, 10)]
  security_groups = [module.consideration_5.security_group.id]

  tags = {
    Name = join("-", [local.name, 5])
  }
}

################################################################################
# Consideration 6
################################################################################

module "consideration_6" {
  source = "../../"

  name        = join("-", [local.name, 6])
  vpc_id      = data.aws_vpc.default.id
  description = "The SG ID must be preserved because it is used by a load balancer"

  computed_ingress = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
      # uncommenting will result in a service interruption for source_security_group_id
      # and we cannot use CBD because it is not support with computed rules.
      # prefix_list_ids        = [aws_ec2_managed_prefix_list.other.id]
    }
  ]
}

# this module rule will have no effect on the source_security_group_id
# module "consideration_6_rules_only" {
#   source = "../../"

#   create_security_group = false
#   security_group_id     = module.consideration_6.security_group.id
#   description           = "This additional rule will preserve the SG ID and will not effect the pre-existing rules."

#   computed_ingress = [
#     {
#       rule            = "https-443-tcp"
#       prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
#     }
#   ]
# }

resource "aws_lb" "consideration_6" {
  name                       = join("-", [substr(local.name, 0, 30), 6])
  drop_invalid_header_fields = true
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [module.consideration_6.security_group.id]
  subnets                    = data.aws_subnets.default.ids

  tags = {
    Name = join("-", [local.name, 6])
  }
}
