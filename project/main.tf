# Configure org policy on a resource tagged as "scope-[random]"
resource "google_org_policy_policy" "scope_random_require_shielded_vm" {
  parent = var.scoped_folder_id
  name   = "${var.scoped_folder_id}/policies/compute.requireShieldedVm"

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

# Configure org policy on a resource tagged through parent
resource "google_org_policy_policy" "implicit_allow_require_shielded_vm" {
  parent = var.inherited_project_id
  name   = "${var.inherited_project_id}/policies/compute.requireShieldedVm"

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

# Configure org policy on a resource tagged as "allow"
resource "google_org_policy_policy" "explicit_allow_require_shielded_vm" {
  parent = var.allowed_project_id
  name   = "${var.allowed_project_id}/policies/compute.requireShieldedVm"

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


# Configure org policy on a resource tagged as "deny" - Will fail
resource "google_org_policy_policy" "explicit_deny_require_shielded_vm" {
  parent = var.denied_project_id
  name   = "${var.denied_project_id}/policies/compute.requireShieldedVm"

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
