###############################################################################
# Security Group
###############################################################################

output "public_https_sg_id" {
  description = "The ID of the public HTTPS security group."
  value       = try(module.public_https_sg.security_group_id, null)
}

output "public_http_sg_id" {
  description = "The ID of the public HTTP security group."
  value       = try(module.public_http_sg.security_group_id, null)
}

output "ssh_sg_id" {
  description = "The ID of the public SSH security group."
  value       = try(module.ssh_sg.security_group_id, null)
}

###############################################################################
# Security Group Rules
###############################################################################

output "public_https_sg_ingress_keys" {
  description = "The public HTTPS security group ingress rules keys."
  value       = try(keys(module.public_https_sg.security_group_ingress_rules), null)
}

output "public_https_sg_egress_keys" {
  description = "The public HTTPS security group egress rules keys."
  value       = try(keys(module.public_https_sg.security_group_egress_rules), null)
}

output "public_http_sg_ingress_keys" {
  description = "The public HTTP security group ingress rules keys."
  value       = try(keys(module.public_http_sg.security_group_ingress_rules), null)
}

output "public_http_sg_egress_keys" {
  description = "The public HTTP security group egress rules keys."
  value       = try(keys(module.public_http_sg.security_group_egress_rules), null)
}

output "ssh_sg_ingress_keys" {
  description = "The SSH security group ingress rules keys."
  value       = try(keys(module.ssh_sg.security_group_ingress_rules), null)
}

output "ssh_sg_egress_keys" {
  description = "The SSH security group egress rules keys."
  value       = try(keys(module.ssh_sg.security_group_egress_rules), null)
}
