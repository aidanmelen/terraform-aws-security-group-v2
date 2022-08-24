locals {
  self_sg_id = var.create && var.create_sg ? aws_security_group.self[0].id : var.security_group_id
}

###############################################################################
# Security Group
###############################################################################

resource "aws_security_group" "self" {
  count                  = var.create && var.create_sg ? 1 : 0
  description            = var.description
  name_prefix            = var.name_prefix
  name                   = var.name
  revoke_rules_on_delete = var.revoke_rules_on_delete
  tags                   = var.tags
  vpc_id                 = var.vpc_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}
