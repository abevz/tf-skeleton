variable "account_id" {
  description = "The only AWS account this configuration may touch."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a 12-digit AWS account id."
  }
}

variable "region" {
  description = "AWS region for every resource in this configuration."
  type        = string
  default     = "eu-central-1"
}

variable "project" {
  description = "Project name; used as the name prefix and the Project tag."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,30}[a-z0-9]$", var.project))
    error_message = "project must be 3-32 characters: lowercase letters, digits and hyphens, starting with a letter."
  }
}

variable "default_tags" {
  description = "Tags applied to every resource through the provider's default_tags."
  type        = map(string)
  default     = {}
  nullable    = false
}
