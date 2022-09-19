locals {
  resource_groups = { for k, v in var.resource_groups : k => {
    location                 = try(v.location, var.default_resource_group_location)
    create_default_ad_groups = try(v.create_default_ad_groups, false)
    ad_groups                = try(v.ad_groups, {})
    iam_role_assignments     = try(v.iam_role_assignments, {})
    consumption_budgets      = try(v.consumption_budgets, {})
  } }
}
