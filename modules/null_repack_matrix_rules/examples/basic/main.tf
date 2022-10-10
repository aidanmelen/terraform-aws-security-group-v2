module "repack" {
  source = "../../"
  matrix = {
    rules = [
      {
        from_port = "443"
        to_port   = "443"
        protocol  = "tcp"
      },
      {
        rule = "http-80-tcp"
      }
    ],
    cidr_blocks              = ["10.0.1.0/24", "10.0.2.0/24"]
    ipv6_cidr_blocks         = ["2001:db8::/64"]
    prefix_list_ids          = [data.aws_prefix_list.private_s3.id]
    source_security_group_id = data.aws_security_group.default.id
    self                     = true
    description              = "managed by Terraform"
  }
}

# Outputs:

# rules = [
#   {
#     "cidr_blocks" = [
#       "10.0.1.0/24",
#       "10.0.2.0/24",
#     ]
#     "from_port" = "443"
#     "ipv6_cidr_blocks" = [
#       "2001:db8::/64",
#     ]
#     "prefix_list_ids" = [
#       "pl-11111111",
#     ]
#     "protocol" = "tcp"
#     "to_port" = "443"
#   },
#   {
#     "cidr_blocks" = [
#       "10.0.1.0/24",
#       "10.0.2.0/24",
#     ]
#     "ipv6_cidr_blocks" = [
#       "2001:db8::/64",
#     ]
#     "prefix_list_ids" = [
#       "pl-11111111",
#     ]
#     "rule" = "http-80-tcp"
#   },
#   {
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "source_security_group_id" = "sg-11111111"
#     "to_port" = "443"
#   },
#   {
#     "rule" = "http-80-tcp"
#     "source_security_group_id" = "sg-11111111"
#   },
#   {
#     "from_port" = "443"
#     "protocol" = "tcp"
#     "self" = true
#     "to_port" = "443"
#   },
#   {
#     "rule" = "http-80-tcp"
#     "self" = true
#   },
# ]
