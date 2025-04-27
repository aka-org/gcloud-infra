# General project settings
variable "env" {
  description = "Infrastructure environment"
  type        = string
  default     = ""
}
variable "project_id" {
  description = "ID of the project that the service account will be associated with"
  type        = string
  default     = ""
}

# Service Account
variable "service_accounts" {
  description = "List of service accounts to be created"
  type = list(object({
    prefix       = string
    description  = string
    roles        = list(string)
    assign_to    = list(string)
    create_key   = bool
  }))
  default = []
}
