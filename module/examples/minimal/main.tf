# The smallest working call. Doubles as documentation and as a fixture for
# integration tests.

module "this" {
  source = "../.."

  name_prefix = "example"
}

output "name" {
  description = "Passed through from the module."
  value       = module.this.name
}
