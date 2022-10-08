###############################################################################
# Security Group
###############################################################################

variable "create" {
  description = "Whether to create security group and all rules"
  type        = bool
  default     = true
}

variable "create_security_group" {
  description = "Whether to create security group and all rules."
  type        = bool
  default     = true
}

variable "security_group_id" {
  description = "ID of existing security group whose rules we will manage."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional, Forces new resource) Security group description. Defaults to Managed by Terraform. Cannot be \"\". NOTE: This field maps to the AWS GroupDescription attribute, for which there is no Update API. If you'd like to classify your security groups in a way that can be updated, use tags."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "(Optional, Forces new resource) Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "name_prefix_separator" {
  description = "(Optional, Only used with name_prefix) The separator between the name_prefix and generated suffix."
  type        = string
  default     = "-"

  validation {
    condition     = length(var.name_prefix_separator) == 1
    error_message = "The \"name_prefix_separator\" must be 1 character long."
  }
}

variable "name" {
  description = "(Optional, Forces new resource) Name of the security group. If omitted, Terraform will assign a random, unique name."
  type        = string
  default     = null
}

variable "revoke_rules_on_delete" {
  description = "(Optional) Instruct Terraform to revoke all of the Security Groups attached ingress and egress rules before deleting the rule itself. This is normally not needed, however certain AWS services such as Elastic Map Reduce may automatically add required rules to security groups used with the service, and those rules may contain a cyclic dependency that prevent the security groups from being destroyed without removing the dependency first. Default false."
  type        = string
  default     = null
}

variable "tags" {
  description = "(Optional) Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}

variable "vpc_id" {
  description = "(Optional, Forces new resource) VPC ID."
  type        = string
  default     = null
}

variable "create_timeout" {
  description = "Time to wait for a security group to be created."
  type        = string
  default     = "10m"
}

variable "delete_timeout" {
  description = "Time to wait for a security group to be deleted."
  type        = string
  default     = "15m"
}

###############################################################################
# Security Group Rules
###############################################################################

variable "ingress" {
  description = "The security group ingress rules. Can be either customer, managed, or common rule."
  type        = any
  default     = []

  validation {
    condition = alltrue(flatten([
      for rule in try(var.ingress, []) : [
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

variable "egress" {
  description = "The security group egress rules. Can be either customer, managed, or common rule."
  type        = any
  default     = []

  validation {
    condition = alltrue(flatten([
      for rule in try(var.egress, []) : [
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

variable "matrix_ingress" {
  description = "A map of module rule(s) and source(s) representing the multi-dimensional matrix ingress rules."
  type        = any
  default     = {}

  validation {
    condition = alltrue(flatten([
      for rule in try(var.matrix_ingress.rules, []) : [
        for key in keys(rule) : contains([
          "rule",
          "from_port",
          "to_port",
          "protocol",
          "description",
        ], key)
      ]
    ]))
    error_message = "At least one of the matrix_ingress.rules keys are invalid. Valid options are: \"rule\", \"from_port\", \"to_port\", or \"protocol\"."
  }

  validation {
    condition = alltrue(flatten([
      for key in keys(try(var.matrix_ingress, {})) : contains([
        "rules",
        "cidr_blocks",
        "ipv6_cidr_blocks",
        "prefix_list_ids",
        "source_security_group_id",
        "self",
        "description",
      ], key)
    ]))
    error_message = "At least one of the matrix_ingress keys are invalid. Valid options are: \"rules\", \"cidr_blocks\", \"ipv6_cidr_blocks\", \"prefix_list_ids\", \"source_security_group_id\", \"self\", or \"description\"."
  }
}

variable "matrix_egress" {
  description = "A map of module rule(s) and destinations(s) representing the multi-dimensional matrix egress rules."
  type        = any
  default     = {}

  validation {
    condition = alltrue(flatten([
      for rule in try(var.matrix_egress.rules, []) : [
        for key in keys(rule) : contains([
          "rule",
          "from_port",
          "to_port",
          "protocol",
          "description",
        ], key)
      ]
    ]))
    error_message = "At least one of the matrix_egress.rules keys are invalid. Valid options are: \"rule\", \"from_port\", \"to_port\", or \"protocol\"."
  }

  validation {
    condition = alltrue(flatten([
      for key in keys(try(var.matrix_egress, {})) : contains([
        "rules",
        "cidr_blocks",
        "ipv6_cidr_blocks",
        "prefix_list_ids",
        "source_security_group_id",
        "self",
        "description",
      ], key)
    ]))
    error_message = "At least one of the matrix_egress keys are invalid. Valid options are: \"rules\", \"cidr_blocks\", \"ipv6_cidr_blocks\", \"prefix_list_ids\", \"source_security_group_id\", \"self\", or \"description\"."
  }
}

variable "computed_ingress" {
  description = "The security group ingress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either customer, managed, or common rule."
  type        = any
  default     = []

  validation {
    condition = alltrue(flatten([
      for rule in try(var.computed_ingress, []) : [
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

variable "computed_egress" {
  description = "The security group egress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either customer, managed, or common rule."
  type        = any
  default     = []

  validation {
    condition = alltrue(flatten([
      for rule in try(var.computed_egress, []) : [
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

variable "computed_matrix_ingress" {
  description = "A map of module rule(s) and source(s) representing the multi-dimensional matrix ingress rules. The matrix may contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc)."
  type        = any
  default     = {}

  validation {
    condition = alltrue(flatten([
      for rule in try(var.computed_matrix_ingress.rules, []) : [
        for key in keys(rule) : contains([
          "rule",
          "from_port",
          "to_port",
          "protocol",
          "description",
        ], key)
      ]
    ]))
    error_message = "At least one of the computed_matrix_ingress.rules keys are invalid. Valid options are: \"rule\", \"from_port\", \"to_port\", or \"protocol\"."
  }

  validation {
    condition = alltrue(flatten([
      for key in keys(try(var.computed_matrix_ingress, {})) : contains([
        "rules",
        "cidr_blocks",
        "ipv6_cidr_blocks",
        "prefix_list_ids",
        "source_security_group_id",
        "self",
        "description",
      ], key)
    ]))
    error_message = "At least one of the computed_matrix_ingress keys are invalid. Valid options are: \"rules\", \"cidr_blocks\", \"ipv6_cidr_blocks\", \"prefix_list_ids\", \"source_security_group_id\", \"self\", or \"description\"."
  }
}

variable "computed_matrix_egress" {
  description = "A map of module rule(s) and destinations(s) representing the multi-dimensional matrix egress rules. The matrix may contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc)."
  type        = any
  default     = {}

  validation {
    condition = alltrue(flatten([
      for rule in try(var.computed_matrix_egress.rules, []) : [
        for key in keys(rule) : contains([
          "rule",
          "from_port",
          "to_port",
          "protocol",
          "description",
        ], key)
      ]
    ]))
    error_message = "At least one of the computed_matrix_egress.rules keys are invalid. Valid options are: \"rule\", \"from_port\", \"to_port\", or \"protocol\"."
  }

  validation {
    condition = alltrue(flatten([
      for key in keys(try(var.computed_matrix_egress, {})) : contains([
        "rules",
        "cidr_blocks",
        "ipv6_cidr_blocks",
        "prefix_list_ids",
        "source_security_group_id",
        "self",
        "description",
      ], key)
    ]))
    error_message = "At least one of the computed_matrix_egress keys are invalid. Valid options are: \"rules\", \"cidr_blocks\", \"ipv6_cidr_blocks\", \"prefix_list_ids\", \"source_security_group_id\", \"self\", or \"description\"."
  }
}

variable "default_rule_description" {
  description = "The default security group rule description."
  type        = string
  default     = "managed by Terraform"
}

variable "unpack" {
  description = "Whether to unpack security group rule arguments. Unpacking will prevent unwanted security group rule updates that regularly occur when arguments are packed together."
  type        = bool
  default     = false
}
