locals {
  name = "ex-${replace(basename(path.cwd), "_", "-")}"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_prefix_list" "private_s3" {
  name = "com.amazonaws.${var.aws_region}.s3"
}
