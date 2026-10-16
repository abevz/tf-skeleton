# Partial backend configuration: only what is the same for every environment
# is written here. Bucket, key and region differ per environment and come from
# envs/<env>.s3.tfbackend:
#
#   tofu init -backend-config=envs/dev.s3.tfbackend
#
# S3 native locking (use_lockfile) needs OpenTofu or Terraform 1.10+ and holds
# the lock in the bucket itself: no DynamoDB table.

terraform {
  backend "s3" {
    encrypt      = true
    use_lockfile = true
  }
}
