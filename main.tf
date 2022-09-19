module "resource_group" {
  for_each = local.resource_groups

  source  = "./modules/resource-group"
  context = module.this.context

  name     = each.key
  location = each.value.location

  ad_groups                                 = each.value.ad_groups
  create_default_ad_groups                  = each.value.create_default_ad_groups
  default_ad_groups_for_resource_containers = var.default_ad_groups_for_resource_containers

  iam_role_assignments = each.value.iam_role_assignments

  consumption_budgets                            = each.value.consumption_budgets
  default_consumption_budget_notification_emails = var.default_consumption_budget_notification_emails
}
