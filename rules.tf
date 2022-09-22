locals {
  rules = merge(
    local.managed_rules,
    local.common_rules,
    local.common_rules_with_type_annotation
  )
}
