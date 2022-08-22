###############################################################################
# Security Group
###############################################################################
variable "create_sg" {
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
# Ingress Rules
###############################################################################
variable "ingress_rules" {
  description = "Map of ingress rules. The key is the rule description and the value are the `aws_security_group_rule` resource arguments."
  type        = any
  default     = {}
}

variable "managed_ingress_rules" {
  description = "Map of managed ingress rules. The key is the rule description and the value is the managed rule name."
  type        = any
  default     = {}
}

###############################################################################
# Egress Rules
###############################################################################
variable "egress_rules" {
  description = "Map of egress rules. The key is the rule description and the value are the `aws_security_group_rule` resource arguments."
  type        = any
  default     = {}
}

variable "managed_egress_rules" {
  description = "Map of managed egress rules. The key is the rule description and the value is the managed rule name."
  type        = any
  default     = {}
}