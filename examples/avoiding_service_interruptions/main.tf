module "consideration_1" {
  source = "../../"

  name        = join("-", [local.name, 1])
  vpc_id      = data.aws_vpc.default.id
  description = "Rules with dynamic keys will use DBC lifecycle management."

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

module "consideration_2" {
  source = "../../"

  name        = join("-", [local.name, 2])
  vpc_id      = data.aws_vpc.default.id
  description = "Rules with user managed keys will use CBD lifecycle management."

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

module "consideration_3" {
  source = "../../"

  name        = join("-", [local.name, 3])
  vpc_id      = data.aws_vpc.default.id
  description = "Avoid rules with multiple subjects."

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
}

module "consideration_4" {
  source = "../../"

  name_prefix = join("-", [local.name, 4])
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

module "consideration_5" {
  source = "../../"

  name_prefix = join("-", [local.name, 5, "blue"])
  # Force a SG level CBD with a name change
  # name_prefix = join("-", [local.name, 5, "green"])
  vpc_id      = data.aws_vpc.default.id
  description = "Use the name_prefix argument when the SG ID does not need to be preserved."

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
}

module "consideration_6" {
  source = "../../"

  name_prefix = join("-", [local.name, 6, "blue"])
  # Force a SG level CBD with a name change
  # name_prefix = join("-", [local.name, 6, "green"])
  vpc_id      = data.aws_vpc.default.id
  description = "This is not supported by the aws provider and should be changed outside of Terraform to avoid a service interruption."

  computed_ingress = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
      # prefix_list_ids        = [aws_ec2_managed_prefix_list.other.id]
    }
  ]
}

# the ENI will updated with the new SG ID after the old SG is destroyed
# thus resulting in a service interruption. The only way to avoid a service interruption
# is to manually change the SG rule outside of terraform and fix TF state after.
resource "aws_network_interface" "consideration_6" {
  subnet_id       = data.aws_subnet.default.id
  private_ips     = [cidrhost(data.aws_subnet.default.cidr_block, 20)]
  security_groups = [module.consideration_6.security_group.id]
}
