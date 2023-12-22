/**
 * # Azure Resource Group wrapper module
 *
 * This module is a wrapper of `getindata/resource-group/azurerm` module,
 * which adds support for Azure AD groups.
 */

module "this_resource_group" {
  source  = "getindata/resource-group/azurerm"
  version = "1.2.0"
  context = module.this.context

  location = var.location

  consumption_budgets                            = var.consumption_budgets
  default_consumption_budget_notification_emails = var.default_consumption_budget_notification_emails
}

module "ad_groups" {
  source  = "getindata/group/azuread"
  version = "1.0.1"

  for_each = local.ad_groups

  context = module.this.context
  name    = each.key
  stage = (lookup(module.this.descriptors, "ad-group-resource-group", null) == null
    ? join(module.this.delimiter, [module.this.name, "rg"])
  : module.this.stage)

  role_assignments = [for role_name in each.value.role_names : {
    scope     = module.this_resource_group.id
    role_name = role_name
  }]
}

data "azuread_user" "this" {
  for_each = module.this.enabled ? local.iam_user_role_assignments : {}

  user_principal_name = each.value.user
}

data "azuread_group" "this" {
  for_each = module.this.enabled ? local.iam_group_role_assignments : {}

  display_name = each.value.group
}

resource "azurerm_role_assignment" "ad_users" {
  for_each = module.this.enabled ? local.iam_user_role_assignments : {}

  principal_id = data.azuread_user.this[each.key].object_id
  scope        = module.this_resource_group.id

  role_definition_name = each.value.role_name
}

resource "azurerm_role_assignment" "ad_group" {
  for_each = module.this.enabled ? local.iam_group_role_assignments : {}

  principal_id = data.azuread_group.this[each.key].object_id
  scope        = module.this_resource_group.id

  role_definition_name = each.value.role_name
}
