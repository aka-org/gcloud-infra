# General project settings
variable "project_id" {
  description = "ID of the project that the service account will be associated with"
  type        = string
  default     = ""
}

# Service Account
variable "service_accounts" {
  description = "List of service accounts to be created"
  type = list(object({
    id          = string
    description = string
    roles       = list(string)
    create_key  = bool
    write_key   = bool
  }))
  default = []
}
