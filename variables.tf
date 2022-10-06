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
}

variable "egress" {
  description = "The security group egress rules. Can be either customer, managed, or common rule."
  type        = any
  default     = []
}

variable "matrix_ingress" {
  description = "A map of module rule(s) and source(s) representing the multi-dimensional matrix ingress rules."
  type        = any
  default     = {}
}

variable "matrix_egress" {
  description = "A map of module rule(s) and destinations(s) representing the multi-dimensional matrix egress rules."
  type        = any
  default     = {}
}

variable "computed_ingress" {
  description = "The security group ingress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either customer, managed, or common rule."
  type        = any
  default     = []
}

variable "computed_egress" {
  description = "The security group egress rules that contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc). Can be either customer, managed, or common rule."
  type        = any
  default     = []
}

variable "computed_matrix_ingress" {
  description = "A map of module rule(s) and source(s) representing the multi-dimensional matrix ingress rules. The matrix may contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc)."
  type        = any
  default     = {}
}

variable "computed_matrix_egress" {
  description = "A map of module rule(s) and destinations(s) representing the multi-dimensional matrix egress rules. The matrix may contain unknown values (e.g. `aws_vpc.vpc.cidr_blocks`, `aws_security_group.sg.id`, etc)."
  type        = any
  default     = {}
}

variable "default_rule_description" {
  description = "The default security group rule description."
  type        = string
  default     = "managed by Terraform"
}

variable "unpack" {
  description = "Whether to unpack grouped security rules. This helps prevent service interruption by removing side-effects caused by updating grouped rules."
  type        = bool
  default     = false
}
