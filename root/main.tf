# Compose modules here; keep resources in modules.
#
# module "network" {
#   source = "./modules/network"
#
#   name_prefix = var.project
# }

locals {
  tags = merge({
    Project   = var.project
    ManagedBy = "opentofu"
  }, var.default_tags)
}
