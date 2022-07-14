# Project deployment

This configures the project-specific [organizational policy constraint](https://cloud.google.com/resource-manager/docs/organization-policy/org-policy-constraints).

The "Deny"-project constraint deployment fails, because the Resource Tag is not included in the CI/CD service account permissions.

## Terraform

| File                       | Resources                      |
|:---------------------------|:-------------------------------|
| [/main.tf](main.tf) | Organizational policy constraints  |
| [/terraform.tf](terraform.tf) | Impersonated provider configuration      |