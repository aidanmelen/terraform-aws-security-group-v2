###############################################################################
# Security Group
###############################################################################

locals {
  security_group_id = var.create && var.create_security_group ? try(
    aws_security_group.self[0].id,
    aws_security_group.self_with_name_prefix[0].id
  ) : var.security_group_id
}

resource "aws_security_group" "self" {
  count                  = var.create && var.create_security_group && var.name_prefix == null ? 1 : 0
  description            = var.description
  name                   = var.name
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = merge({ "Name" : var.name }, var.tags)
  vpc_id                 = var.vpc_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}

resource "aws_security_group" "self_with_name_prefix" {
  count                  = var.create && var.create_security_group && var.name_prefix != null ? 1 : 0
  description            = var.description
  name_prefix            = format("%s%s", var.name_prefix, var.name_prefix_separator)
  revoke_rules_on_delete = var.revoke_rules_on_delete
  vpc_id                 = var.vpc_id
  tags                   = merge({ "Name" : var.name != null ? var.name : var.name_prefix }, var.tags)

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}
