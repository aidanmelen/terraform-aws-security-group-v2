###############################################################################
# Common Ingress Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "ingress_all_from_self_rules" {

  # create terraform resource with identifiable ID
  for_each = var.create && var.create_ingress_all_from_self_rules ? { "ingress-all-all-from-self" = null } : {}

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = "Opening up ingress all ports from self security group."

  from_port = -1
  to_port   = -1
  protocol  = "-1"

  self = true
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "ingress_https_from_public_rules" {

  # create terraform resource with identifiable ID
  for_each = var.create && var.create_ingress_https_from_public_rules ? { "ingress-https-443-tcp-from-public" = null } : {}

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = "Opening up ingress HTTPS from the public internet."

  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "ingress_http_from_public_rules" {

  # create terraform resource with identifiable ID
  for_each = var.create && var.create_ingress_http_from_public_rules ? { "ingress-http-80-tcp-from-public" = null } : {}

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = "Opening up ingress HTTP from the public internet. Please consider using HTTPS instead."

  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}

###############################################################################
# Common Egress Rules
###############################################################################

#tfsec:ignore:aws-ec2-no-public-ingress-sgr tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "egress_all_to_public_rules" {

  # create terraform resource with identifiable ID
  for_each = var.create && var.create_egress_all_to_public_rules ? { "egress-all-all-to-public" = null } : {}

  type              = "egress"
  security_group_id = local.self_sg_id
  description       = "Opening up ports to connect out to the public internet is generally to be avoided. Please see [no-public-egress-sgr](https://aquasecurity.github.io/tfsec/v0.61.3/checks/aws/vpc/no-public-egress-sgr/) for more information"

  from_port = 0
  to_port   = 0
  protocol  = "-1"

  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
}
