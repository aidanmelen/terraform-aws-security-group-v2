data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

resource "aws_ec2_managed_prefix_list" "example" {
  name           = "Example"
  address_family = "IPv4"
  max_entries    = 5
}

resource "aws_ec2_managed_prefix_list_entry" "entry_1" {
  cidr           = "10.10.0.0/20"
  description    = "Service name"
  prefix_list_id = aws_ec2_managed_prefix_list.example.id
}