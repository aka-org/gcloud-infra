terraform {
  backend "gcs" {
    bucket = "aka-org-testing-636c5fa4-tf-states"
    prefix = "project"
  }
}
