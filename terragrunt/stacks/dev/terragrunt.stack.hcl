# One environment = one stack of units.
#
#   terragrunt stack run plan
#   terragrunt stack run apply
#
# Dependency order comes from the dependency blocks inside each unit, not from
# the order here.

locals {
  units = "${get_repo_root()}/units"
}

unit "example" {
  source = "${local.units}/example"
  path   = "example"
}
