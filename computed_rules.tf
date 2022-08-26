###############################################################################
# Computed Custom Security Group Rules
###############################################################################

locals {
  computed_rules = {
    for rule in concat(
      aws_security_group_rule.computed_ingress_rules,
      aws_security_group_rule.computed_egress_rules
      ) : join("-", compact([
        rule["type"],
        rule["to_port"],
        rule["from_port"],
        rule["protocol"],
        rule["type"] == "ingress" ? "from" : "to",
        try(join(",", rule["cidr_blocks"]), null),
        try(join(",", rule["ipv6_cidr_blocks"]), null),
        try(join(",", rule["prefix_list_ids"]), null),
        rule["self"] == true ? rule["self"] : null,
        try(rule["source_security_group_id"], null),
    ])) => rule
  }
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_ingress_rules" {
  count = var.create ? length(var.computed_ingress_rules) : 0

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_ingress_rules[count.index], "description", "Managed by Terraform")

  from_port = var.computed_ingress_rules[count.index]["from_port"]
  to_port   = var.computed_ingress_rules[count.index]["to_port"]
  protocol  = var.computed_ingress_rules[count.index]["protocol"]

  cidr_blocks              = lookup(var.computed_ingress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_ingress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_ingress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_ingress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_ingress_rules[count.index], "source_security_group_id", null)
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_egress_rules" {
  count = var.create ? length(var.computed_egress_rules) : 0

  type              = "egress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_egress_rules[count.index], "description", "Managed by Terraform")

  from_port = var.computed_egress_rules[count.index]["from_port"]
  to_port   = var.computed_egress_rules[count.index]["to_port"]
  protocol  = var.computed_egress_rules[count.index]["protocol"]

  cidr_blocks              = lookup(var.computed_egress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_egress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_egress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_egress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_egress_rules[count.index], "source_security_group_id", null)
}

###############################################################################
# Computed Managed Security Group Rules
###############################################################################

locals {
  computed_managed_rules = {
    for rule in concat(
      aws_security_group_rule.computed_managed_ingress_rules,
      aws_security_group_rule.computed_managed_egress_rules,
      ) : join("-", compact([
        rule["type"],
        rule["to_port"],
        rule["from_port"],
        rule["protocol"],
        rule["type"] == "ingress" ? "from" : "to",
        try(join(",", rule["cidr_blocks"]), null),
        try(join(",", rule["ipv6_cidr_blocks"]), null),
        try(join(",", rule["prefix_list_ids"]), null),
        rule["self"] == true ? rule["self"] : null,
        try(rule["source_security_group_id"], null),
    ])) => rule
  }
}

#tfsec:ignore:aws-ec2-no-public-ingress-sgr
resource "aws_security_group_rule" "computed_managed_ingress_rules" {
  count = var.create ? length(var.computed_managed_ingress_rules) : 0

  type              = "ingress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_managed_ingress_rules[count.index], "description", var.computed_managed_ingress_rules[count.index]["rule"])

  from_port = local.managed_rule_definitions[lookup(var.computed_managed_ingress_rules[count.index], "rule", "_")]["from_port"]
  to_port   = local.managed_rule_definitions[lookup(var.computed_managed_ingress_rules[count.index], "rule", "_")]["to_port"]
  protocol  = local.managed_rule_definitions[lookup(var.computed_managed_ingress_rules[count.index], "rule", "_")]["protocol"]

  cidr_blocks              = lookup(var.computed_managed_ingress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_managed_ingress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_managed_ingress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_managed_ingress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_managed_ingress_rules[count.index], "source_security_group_id", null)
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "computed_managed_egress_rules" {
  count = var.create ? length(var.computed_managed_egress_rules) : 0

  type              = "egress"
  security_group_id = local.self_sg_id
  description       = lookup(var.computed_managed_egress_rules[count.index], "description", var.computed_managed_egress_rules[count.index]["rule"])

  from_port = local.managed_rule_definitions[lookup(var.computed_managed_ingress_rules[count.index], "rule", "_")]["from_port"]
  to_port   = local.managed_rule_definitions[lookup(var.computed_managed_ingress_rules[count.index], "rule", "_")]["to_port"]
  protocol  = local.managed_rule_definitions[lookup(var.computed_managed_ingress_rules[count.index], "rule", "_")]["protocol"]

  cidr_blocks              = lookup(var.computed_managed_egress_rules[count.index], "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(var.computed_managed_egress_rules[count.index], "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(var.computed_managed_egress_rules[count.index], "prefix_list_ids", null)
  self                     = lookup(var.computed_managed_egress_rules[count.index], "self", null)
  source_security_group_id = lookup(var.computed_managed_egress_rules[count.index], "source_security_group_id", null)
}
