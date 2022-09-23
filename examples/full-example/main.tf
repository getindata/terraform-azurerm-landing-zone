module "this_landing_zone" {
  source  = "../../"
  context = module.this.context

  default_resource_group_location                = "West Europe"
  default_consumption_budget_notification_emails = ["default-notifications@example.com"]
  default_consumption_budgets_notifications = {
    default-actual-80 = {
      contact_emails = ["notify@example.com"]
      operator       = "GreaterThan"
      threshold      = 80
      threshold_type = "Actual"
    }
  }

  resource_groups = {
    foo-rg = {
      consumption_budgets = {
        default = {
          amount = 100
        }
      }
    }
    bar-rg = {
      ad_groups = {
        security-readers = {
          role_names = ["Security Reader"]
        }
      }
      consumption_budgets = {
        default = {
          amount                        = 100
          default_notifications_enabled = false
          notifications = {
            default-forecasted-100 = {
              contact_emails = ["notify@example.com"]
              operator       = "GreaterThan"
              threshold      = 100
              threshold_type = "Forecasted"
            }
          }
        }
      }
    }
  }
}
