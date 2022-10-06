variable "create" {
  description = "Whether to create security group rules"
  type        = bool
  default     = true
}

variable "rules" {
  description = "The grouped security rules to unpack into dedicated security group rules."
  type        = any

  validation {
    condition = alltrue([
      for rule in var.rules : rule if contains([
        "type",
        "rule",
        "from_port",
        "to_port",
        "protocol",
        "cidr_blocks",
        "ipv6_cidr_blocks",
        "prefix_list_ids",
        "source_security_group_id",
        "self",
        "description",
      ], keys(rule))
    ])
    error_message = "Each rule must have the following keys: \"type\", \"rule\", \"from_port\", \"to_port\", \"protocol\", \"cidr_blocks\", \"ipv6_cidr_blocks\", \"prefix_list_ids\", \"source_security_group_id\", \"self\", \"description\"."
  }
}
