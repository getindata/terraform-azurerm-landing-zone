module "this_landing_zone" {
  source  = "../../"
  context = module.this.context

  default_resource_group_location = "West Europe"
  resource_groups = {
    example-rg = {
      ad_groups = {
        security-readers = {
          role_names = ["Security Reader"]
        }
      }
      consumption_budgets = {
        default = {
          amount = 100
          time_period = {
            start_date = "2022-07-01T00:00:00Z"
          }
          notifications = {
            forecastedGreaterThan100 = {
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
