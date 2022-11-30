variable "create" {
  description = "Whether to create security group rules"
  type        = bool
  default     = true
}

variable "matrix" {
  description = "The security group matrix rule arguments to normalize."
  type        = any

  validation {
    condition = alltrue(flatten([
      for key in try(keys(var.matrix), []) : contains([
        "rules",
        "cidr_blocks",
        "ipv6_cidr_blocks",
        "prefix_list_ids",
        "source_security_group_id",
        "source_security_group_ids",
        "self",
        "description",
      ], key)
    ]))
    error_message = "At least one of the required matrix arguments are invalid. Please check rule has required keys:\n\n\t${join("\n\t", ["rules", "cidr_blocks", "ipv6_cidr_blocks", "prefix_list_ids", "source_security_group_id", "source_security_group_ids", "self", "description"])}"
  }

  validation {
    condition = alltrue(flatten([
      for rule in try(var.matrix.rules, []) : [
        for key in keys(rule) : contains([
          "rule",
          "from_port",
          "to_port",
          "protocol",
          "description",
        ], key)
      ]
    ]))
    error_message = "At least one of the required matrix[*].rule arguments are invalid. Please check rule has required keys:\n\n\t${join("\n\t", ["rule", "from_port", "protocol", "to_port", "description"])}"
  }
}
