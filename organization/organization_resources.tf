resource "google_folder" "scope_random" {
  parent       = data.google_organization.org.name
  display_name = "scope-${random_id.deployment.hex}"
}

# Grant Terraform principal permission to assign tags to folder
resource "google_folder_iam_member" "scope_random_tag_user" {
  folder  = google_folder.scope_random.id
  role    = "roles/resourcemanager.tagUser"
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}

# Tag folder as "Scope"
resource "google_tags_tag_binding" "scope_random_scope_folder_scope_random" {
  tag_value = google_tags_tag_value.org_policy_scope_random.id
  parent    = "//cloudresourcemanager.googleapis.com/${google_folder.scope_random.id}"

  depends_on = [
    google_tags_tag_key_iam_member.org_policy_scope_user,
    google_folder_iam_member.scope_random_tag_user,
  ]
}

resource "google_project" "explicit_allow" {
  folder_id  = google_folder.scope_random.name
  project_id = "org-pol-${random_id.deployment.hex}-allow-expl"
  name       = "org-pol-allow-expl"
}

# Grant Terraform principal permission to assign tags to project
resource "google_project_iam_member" "explicit_allow_tag_user" {
  project = google_project.explicit_allow.id
  role    = "roles/resourcemanager.tagUser"
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}

# Tag project as "Allowed", overrides parent "Scope"
resource "google_tags_tag_binding" "scope_random_allow_project_explicit_allow" {
  tag_value = google_tags_tag_value.org_policy_allow.id
  parent    = "//cloudresourcemanager.googleapis.com/projects/${google_project.explicit_allow.number}"

  depends_on = [
    google_tags_tag_key_iam_member.org_policy_scope_user,
    google_project_iam_member.explicit_allow_tag_user,
  ]
}

resource "google_project" "implicit_allow" {
  folder_id  = google_folder.scope_random.name
  project_id = "org-pol-${random_id.deployment.hex}-allow-impl"
  name       = "org-pol-allow-impl"
}

# Grant Terraform principal permission to assign tags to project
resource "google_project_iam_member" "implicit_allow_tag_user" {
  project = google_project.implicit_allow.id
  role    = "roles/resourcemanager.tagUser"
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}

resource "google_project" "explicit_deny" {
  folder_id  = google_folder.scope_random.name
  project_id = "org-pol-${random_id.deployment.hex}-deny-expl"
  name       = "org-pol-deny-expl"
}

# Grant Terraform principal permission to assign tags to project
resource "google_project_iam_member" "explicit_deny_tag_user" {
  project = google_project.explicit_deny.id
  role    = "roles/resourcemanager.tagUser"
  member  = "user:${data.google_client_openid_userinfo.me.email}"
}

# Tag project as "Denied", overrides parent "Scope"
resource "google_tags_tag_binding" "scope_random_deny_project_explicit_deny" {
  tag_value = google_tags_tag_value.org_policy_deny.id
  parent    = "//cloudresourcemanager.googleapis.com/projects/${google_project.explicit_deny.number}"

  depends_on = [
    google_tags_tag_key_iam_member.org_policy_scope_user,
    google_project_iam_member.explicit_deny_tag_user,
  ]
}
