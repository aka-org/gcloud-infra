# Google APIs
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = ""
}
variable "enable_apis" {
  description = "Lists of Google APIs to be enabled"
  type        = list(string)
  default     = []
}
