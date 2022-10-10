variable "create" {
  description = "Whether to create security group rules"
  type        = bool
  default     = true
}

variable "rules" {
  description = "The security group rule arguments to unpack."
  type        = any

  validation {
    condition = alltrue([
      for rule in try(var.rules, []) : sort(keys(rule)) == sort([
        "from_port",
        "to_port",
        "protocol",
        "cidr_blocks",
        "ipv6_cidr_blocks",
        "prefix_list_ids",
        "source_security_group_id",
        "self",
        "description",
      ])
    ])
    error_message = "At least one of the required rule arguments are missing or invalid. Please check rule has required keys:\n\n\t${join("\n\t", ["from_port", "protocol", "to_port", "cidr_blocks", "description", "ipv6_cidr_blocks", "prefix_list_ids", "self", "source_security_group_id"])}"
  }
}
