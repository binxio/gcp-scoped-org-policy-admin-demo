resource "google_tags_tag_key" "org_policy_scope" {
  parent = data.google_organization.org.name

  short_name  = "org-policy-scope-${random_id.deployment.hex}"
  description = "Scoping tag for organization policy constraint management."
}

# Allow provider to bind tags to resources
resource "google_tags_tag_key_iam_member" "org_policy_scope_user" {
  tag_key = google_tags_tag_key.org_policy_scope.name
  role    = "roles/resourcemanager.tagUser"
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}

resource "google_tags_tag_value" "org_policy_scope_random" {
  parent      = google_tags_tag_key.org_policy_scope.id
  short_name  = "scope-${random_id.deployment.hex}"
  description = "Org policy scope (random) tag."
}

resource "google_tags_tag_value" "org_policy_allow" {
  parent      = google_tags_tag_key.org_policy_scope.id
  short_name  = "allow"
  description = "Org policy allow tag."
}

resource "google_tags_tag_value" "org_policy_deny" {
  parent      = google_tags_tag_key.org_policy_scope.id
  short_name  = "deny"
  description = "Org policy deny tag."
}
