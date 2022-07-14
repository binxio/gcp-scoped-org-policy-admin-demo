# Test that sandbox principal cannot change production resource policy
resource "google_service_account" "cicd_org_policy_admin" {
  project      = var.cicd_project_id
  account_id   = "scoped-org-policy-admin-${random_id.deployment.hex}"
  display_name = "Scoped organization policy admin."
}

# Grant Terraform principal permission to impersonate scoped org policy admin
resource "google_service_account_iam_member" "cicd_org_policy_admin_impersonate" {
  service_account_id = google_service_account.cicd_org_policy_admin.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "user:${data.google_client_openid_userinfo.me.email}"
}

# Grant policy admin permission to manage org policies for resources tagged with 'org/org-policy-scope/scope-[random]'
resource "google_organization_iam_member" "cicd_org_policy_admin_scope_random" {
  org_id = data.google_organization.org.org_id
  role   = "roles/orgpolicy.policyAdmin"
  member = "serviceAccount:${google_service_account.cicd_org_policy_admin.email}"

  condition {
    title = "scope-${random_id.deployment.hex}"
    expression = "resource.matchTagId('${google_tags_tag_key.org_policy_scope.id}', '${google_tags_tag_value.org_policy_scope_random.id}')"
  }
}

# Grant policy admin permission to manage org policies for resources tagged with 'org/org-policy-scope/allow'
resource "google_organization_iam_member" "cicd_org_policy_admin_explicit_allow" {
  org_id = data.google_organization.org.org_id
  role   = "roles/orgpolicy.policyAdmin"
  member = "serviceAccount:${google_service_account.cicd_org_policy_admin.email}"

  condition {
    title = "explicit-allow"
    expression = "resource.matchTagId('${google_tags_tag_key.org_policy_scope.id}', '${google_tags_tag_value.org_policy_allow.id}')"
  }
}
