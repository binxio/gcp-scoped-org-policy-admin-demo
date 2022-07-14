variable "cicd_service_account_email" {
  type    = string
  default = "scoped-org-policy-admin@@laurens-knoll-sandbox.iam.gserviceaccount.com"
}

variable "scoped_folder_id" {
  type = string
  default = "folders/xxx"
}

variable "allowed_project_id" {
  type = string
  default = "projects/xxx"
}

variable "inherited_project_id" {
  type = string
  default = "projects/xxx"
}

variable "denied_project_id" {
  type = string
  default = "projects/xxx"
}