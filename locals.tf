locals {
  resource_groups = { for k, v in var.resource_groups : k => {
    location                 = try(v.location, var.default_resource_group_location)
    create_default_ad_groups = try(v.create_default_ad_groups, false)
    ad_groups                = try(v.ad_groups, {})
    iam_role_assignments     = try(v.iam_role_assignments, {})
    consumption_budgets = { for budget_name, budget in try(v.budgets, {}) : budget_name => {
      amount = budget.amount
      time_period = {
        start_date = can(budget.time_period) ? lookup(budget.time_period, "start_date", null) : null
        end_date   = can(budget.time_period) ? lookup(budget.time_period, "end_date", null) : null
      }
      #If default notification enabled, merge them with the provided ones
      notifications = { for notification_name, notification in merge(
        lookup(budget, "default_notifications_enabled", true) ? var.default_consumption_budgets_notifications : {}, lookup(budget, "notifications", {})
        ) : notification_name => merge(notification, {
          contact_emails = concat(notification.contact_emails, lookup(budget, "default_contact_emails", []), )
      }) }
    } }
  } }
}
