# Expose stable, small values (ids, ARNs, names), never whole provider objects.

output "name" {
  description = "Name prefix the module resolved; replace with real outputs."
  value       = local.name
}

output "tags" {
  description = "Tags the module applies in addition to provider default_tags."
  value       = local.tags
}
