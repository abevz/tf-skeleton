# Partial backend configuration: the bucket and key are per person and per
# project, so they live in the gitignored backend.hcl (see backend.hcl.example):
#
#   tofu init -backend-config=backend.hcl
#
# S3 native locking (use_lockfile) needs OpenTofu or Terraform 1.10+ and holds
# the lock in the bucket itself: no DynamoDB table.

terraform {
  backend "s3" {
    encrypt      = true
    use_lockfile = true
  }
}
