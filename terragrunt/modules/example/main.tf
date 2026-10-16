# Resources go here. Keep the module single-purpose: one logical group of
# connected resources (a VPC with its subnets, a bucket with its policy).
#
# Naming: descriptive resource names (aws_s3_bucket.artifacts), `this` only for
# a genuine singleton. Prefer for_each over count for anything that can change.
#
# Block order inside a resource: count/for_each → arguments → tags →
# depends_on → lifecycle.

locals {
  name = var.name_prefix

  tags = merge(var.tags, {
    Module = "REPLACE-ME"
  })
}
