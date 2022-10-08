variable "create" {
  description = "Whether to create security group rules"
  type        = bool
  default     = true
}

variable "rules" {
  description = "The security group rule arguments to unpack."
  type        = any

  validation {
    condition = alltrue(flatten([
      for rule in var.rules : [
        for key in keys(rule) : contains([
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
        ], key)
      ]
    ]))
    error_message = "At least one of the rule keys are invalid. Valid options are: \"rule\", \"from_port\", \"to_port\", \"protocol\", \"cidr_blocks\", \"ipv6_cidr_blocks\", \"prefix_list_ids\", \"source_security_group_id\", \"self\", or \"description\"."
  }
}
