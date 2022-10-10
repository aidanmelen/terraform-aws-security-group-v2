module "unpack" {
  source = "../../"
  rules = [
    {
      from_port                = "443"
      to_port                  = "443"
      protocol                 = "tcp"
      cidr_blocks              = ["10.0.1.0/24", "10.0.2.0/24"]
      ipv6_cidr_blocks         = ["2001:db8::/64"]
      prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
      source_security_group_id = data.aws_security_group.default.id
      self                     = true
      description              = "managed by Terraform"
    }
  ]
}

# Outputs:

# rules = [
#   {
#     "cidr_blocks" = [
#       "10.0.1.0/24",
#     ]
#     "description" = "managed by Terraform"
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "to_port" = "443"
#   },
#   {
#     "cidr_blocks" = [
#       "10.0.2.0/24",
#     ]
#     "description" = "managed by Terraform"
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "to_port" = "443"
#   },
#   {
#     "description" = "managed by Terraform"
#     "from_port" = "443"
#     "ipv6_cidr_blocks" = [
#       "2001:db8::/64",
#     ]
#     "protocol" = "tcp"
#     "to_port" = "443"
#   },
#   {
#     "description" = "managed by Terraform"
#     "from_port" = "443"
#     "prefix_list_ids" = [
#       "pl-11111111",
#     ]
#     "protocol" = "tcp"
#     "to_port" = "443"
#   },
#   {
#     "description" = "managed by Terraform"
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "self" = true
#     "to_port" = "443"
#   },
#   {
#     "description" = "managed by Terraform"
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "source_security_group_id" = "sg-11111111"
#     "to_port" = "443"
#   },
# ]
