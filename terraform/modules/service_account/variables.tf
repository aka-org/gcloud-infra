# Service Account
variable "project_id" {
  description = "ID of the project that the service account will be associated with"
  type        = string
  default     = ""
}
variable "service_accounts" {
  description = "List of service accounts to be created"
  type = list(object({
    id           = string
    display_name = string
    roles        = list(string)
    create_key   = bool
  }))
  default = []
}
