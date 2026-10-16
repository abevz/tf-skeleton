variable "region" {
  description = "AWS region, passed in from root.hcl inputs."
  type        = string
}

variable "project" {
  description = "Project name, passed in from root.hcl inputs."
  type        = string
}

variable "name_prefix" {
  description = "Prefix for every resource name this module creates."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}[a-z0-9]$", var.name_prefix))
    error_message = "name_prefix must be 3-32 characters: lowercase letters, digits and hyphens, starting with a letter."
  }
}

variable "tags" {
  description = "Extra tags for this module's resources, on top of provider default_tags."
  type        = map(string)
  default     = {}
  nullable    = false
}
