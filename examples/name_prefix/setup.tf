locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

data "aws_vpc" "default" {
  default = true
}
