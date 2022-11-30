locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}
