# Root configuration every unit includes:
#
#   include "root" {
#     path = find_in_parent_folders("root.hcl")
#   }
#
# It owns the three things no unit should repeat: where state lives, how the
# provider is configured, and which transient failures are worth retrying.
# Nothing here creates infrastructure. Units live in units/<name>/, the
# Terraform they run in modules/<name>/, environments in stacks/<env>/.
#
# Adapted from aws-community-central-asia-2026/infra/root.hcl.

locals {
  # Per-person values come from the gitignored local.hcl (see local.hcl.example)
  # or from the environment, so nothing account-specific is committed.
  local_overrides = fileexists("${get_parent_terragrunt_dir()}/local.hcl") ? read_terragrunt_config("${get_parent_terragrunt_dir()}/local.hcl").locals : {}

  account_id = get_env("TG_ACCOUNT_ID", lookup(local.local_overrides, "account_id", ""))
  region     = get_env("TG_REGION", lookup(local.local_overrides, "region", "eu-central-1"))
  project    = "REPLACE-ME"

  # Pre-existing bucket, versioning on.
  state_bucket = "${local.account_id}-${local.region}-terraform-states"

  # Units extend this through inputs.default_tags.
  base_tags = {
    Project   = local.project
    ManagedBy = "terragrunt"
    Repo      = "REPLACE-ME"
  }
}

# ── state ────────────────────────────────────────────────────────────────────
# S3 native locking: OpenTofu/Terraform 1.10+ keep the lock in the bucket.

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket = local.state_bucket
    # Units generated from a stack sit under .terragrunt-stack/; stripping it
    # keeps state keys stable if the stack layout changes.
    key          = "${local.project}/${replace(path_relative_to_include(), "/.terragrunt-stack/", "/")}/tofu.tfstate"
    region       = local.region
    encrypt      = true
    use_lockfile = true
  }
}

# ── provider ─────────────────────────────────────────────────────────────────
# default_tags is a variable, so a unit extends tags through plain inputs
# instead of regenerating the provider block.

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<-HCL
    variable "default_tags" {
      description = "Tags applied to every resource this unit creates."
      type        = map(string)
      default     = {}
    }

    provider "aws" {
      region = "${local.region}"

      # A wrong-account apply is the one mistake that is expensive to undo.
      allowed_account_ids = ["${local.account_id}"]

      default_tags {
        tags = var.default_tags
      }
    }
  HCL
}

# ── retries ──────────────────────────────────────────────────────────────────
# Eventual consistency and throttling are worth another attempt; an IAM denial
# or a quota refusal is not.

errors {
  retry "aws_transient" {
    retryable_errors = [
      "(?s).*RequestError: send request failed.*",
      "(?s).*ThrottlingException.*",
      "(?s).*Throttling: Rate exceeded.*",
      "(?s).*RequestLimitExceeded.*",
      "(?s).*connection reset by peer.*",
      "(?s).*TLS handshake timeout.*",
    ]
    max_attempts       = 3
    sleep_interval_sec = 8
  }
}

inputs = {
  region       = local.region
  project      = local.project
  default_tags = local.base_tags
}
