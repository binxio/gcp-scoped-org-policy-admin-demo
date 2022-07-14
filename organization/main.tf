data "google_organization" "org" {
  domain = var.domain
}

data "google_client_openid_userinfo" "me" {
}

resource "random_id" "deployment" {
  byte_length = 2
}

resource "google_project_service" "orgpolicy_googleapis_com" {
  project = var.cicd_project_id
  service = "orgpolicy.googleapis.com"
}
