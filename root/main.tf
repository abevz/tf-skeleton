# Compose modules here; keep resources in modules.
#
# module "network" {
#   source = "./modules/network"
#
#   name_prefix = var.project
# }

locals {
  # Project and ManagedBy are fixed here; envs/<env>.tfvars adds the rest.
  tags = merge({
    Project   = var.project
    ManagedBy = "opentofu"
  }, var.default_tags)
}
