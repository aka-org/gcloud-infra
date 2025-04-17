# Service Account
/*
variable "sa_id" {
  description = "The ID for the service account (e.g., 'terraform-sa')"
  type        = string
  default     = ""
}
variable "sa_display_name" {
  description = "Display name for the service account"
  type        = string
  default     = ""
}
variable "sa_project_id" {
  description = "ID of the project that the service account will be associated with"
  type        = string
  default     = ""
}
variable "sa_pub_key" {
  description = "Public ssh key used for os login by the service account"
  type        = string
  default     = ""
}
variable "sa_roles" {
 description = "List of IAM roles to bind to the service account"
  type        = list(string)
  default = []
}
variable "sa_create_key" {
 description = "Set to true to generate and store locally a base64 encoded authentication key"
  type        = bool
  default = false
}
*/
variable "project_id" {
  description = "ID of the project that the service account will be associated with"
  type        = string
  default     = ""
}
variable "service_accounts" {
 description = "List of service accounts to be created"
  type        = list(object({
    id  = string
    display_name = string
    roles = list(string)
    pub_key = string
    create_key = bool
  }))
  default = []
}
