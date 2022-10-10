locals {
  debug = var.debug ? {
    ingress_normalize        = try(module.ingress_unpack[0].rules, local.ingress_normalize)
    egress_normalize         = try(module.egress_unpack[0].rules, local.egress_normalize)
    ingress_map              = local.ingress_map
    egress_map               = local.egress_map
    matrix_ingress_repack    = module.matrix_ingress_repack.rules
    matrix_egress_repack     = module.matrix_egress_repack.rules
    matrix_ingress_normalize = try(module.matrix_ingress_unpack[0].rules, local.matrix_ingress_normalize)
    matrix_egress_normalize  = try(module.matrix_egress_unpack[0].rules, local.matrix_egress_normalize)
    matrix_ingress_map       = local.matrix_ingress_map
    matrix_egress_map        = local.matrix_egress_map
  } : null
}
