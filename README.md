# Scoped Organization Policy Administration Demo

[Organization Policy Constraints](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints) are managed at the Google Cloud Organization level. This means, that anyone with the Organization Policy Administrator (roles/orgpolicy.policyAdmin) role, can set any policy constraint.

This repository shows how to limit these permissions to a specific set of resources using [Resource Tags](https://cloud.google.com/resource-manager/docs/tags/tags-overview) and [IAM conditions](https://cloud.google.com/iam/docs/conditions-overview#resource_attributes).

## Scoped Organization Policy Admin Terraform Example

First, define the Resource Tag for your scope.

```hcl
resource "google_tags_tag_key" "org_policy_scope" {
  parent = data.google_organization.org.name

  short_name  = "org-policy-scope"
  description = "Scoping tag for organization policy constraint management."
}

resource "google_tags_tag_value" "org_policy_scope_my_scope" {
  parent      = google_tags_tag_key.org_policy_scope.id
  short_name  = "my-scope"
  description = "Org policy scope (my-scope) tag."
}
```

Second, conditionally assign the Policy Administrator permission.

```hcl
resource "google_organization_iam_member" "cicd_org_policy_admin_scope_my_scope" {
  org_id = data.google_organization.org.org_id
  role   = "roles/orgpolicy.policyAdmin"
  member = "serviceAccount:${google_service_account.cicd_org_policy_admin.email}"

  condition {
    title = "my-scope"
    expression = "resource.matchTagId('${google_tags_tag_key.org_policy_scope.id}', '${google_tags_tag_value.org_policy_scope_my_scope.id}')"
  }
}
```

Third, bind the tag to applicable resources.

```hcl
resource "google_project" "example" {
  project_id = "org-pol-admin-example"
  name       = "org-pol-admin-example"
}

resource "google_tags_tag_binding" "scope_my_scope_allow_project_example" {
  tag_value = google_tags_tag_value.org_policy_scope_my_scope.id
  parent    = "//cloudresourcemanager.googleapis.com/projects/${google_project.example.number}"
}
```

Finally, deploy the organization policy constraint.

```hcl
resource "google_org_policy_policy" "scope_my_scope_require_shielded_vm" {
  parent = google_project.example.id
  name   = "${google_project.example.id}/policies/compute.requireShieldedVm"

  spec {
    inherit_from_parent = false

    rules {
      enforce = "TRUE"
    }
  }

  timeouts {
    create = "1m"
  }
}
```

For more information, check the associated [blog post](https://binx.io/2022/07/21/scoped-organizational-policy-constraints-administration).

## Deployment

1. Deploy the organization structure and resource tags using the [organization](organization/README.md) Terraform configuration.
2. Deploy the project specific policies using the [project](project/README.md) Terraform configuration.
