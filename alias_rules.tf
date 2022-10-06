locals {
  rule_aliases = merge(
    local.managed_rule_aliases,
    local.common_rule_aliases,
    local.common_rule_aliases_with_type_annotation
  )
}
