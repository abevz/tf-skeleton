include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("root.hcl"))
}

terraform {
  # The double slash keeps the whole modules/ tree in the cache, so modules can
  # reference each other with relative paths.
  source = "${get_repo_root()}/modules//example"
}

# dependency "network" {
#   config_path = "../network"
#
#   mock_outputs = {
#     vpc_id = "vpc-00000000"
#   }
#   mock_outputs_allowed_terraform_commands = ["validate", "plan"]
# }

inputs = {
  name_prefix = local.root.locals.project

  default_tags = merge(local.root.locals.base_tags, {
    Component = "example"
  })
}
