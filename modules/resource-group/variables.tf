variable "ad_groups" {
  type = map(object({
    role_names : list(string)
  }))
  description = "List of AD groups with role names that will be created with the resource group scope"
  default     = {}
}

variable "default_ad_groups_for_resource_containers" {
  type = map(object({
    role_names : list(string)
  }))
  description = "Map of default AD groups that will be created for the resource group if enabled"
  default     = {}
}

variable "create_default_ad_groups" {
  type        = bool
  description = "Indicates wherever the default AD groups should be created for the resource group"
  default     = false
}

variable "iam_role_assignments" {
  type        = any
  description = "List of AD users with role names that assigned to the resource group scope"
  default     = {}
}

###################################################
## Downstream resource group module variables
###################################################

variable "location" {
  type        = string
  description = "The Azure Region where the resource group should exist."
}

variable "consumption_budgets" {
  type        = map(any)
  default     = {}
  description = <<-EOT
    Consumption budget resources associated with this resource group, it should be a map of values:
    `{
      amount = number
      time_period = object
      notifications = map
      #optional
      time_grain = string
    }`
    `time_period` is an object of `start_date` (which is required) and `end_date` (which is optional).
    `time_grain` must be one of Monthly, Quarterly, Annually, BillingMonth, BillingQuarter, or BillingYear. Defaults to Monthly
    `notifications` is a map of values:
    `{
      #optional
      contact_emails = list(string)
      operator = string
      threshold = string
      threshold_type = string
    }`
    `contact_emails` is a list of email addresses to send the budget notification to when the threshold is exceeded
    `operator` - the comparison operator for the notification. Must be one of EqualTo, GreaterThan, or GreaterThanOrEqualTo. Defaults to `EqualTo`
    `threshold` - threshold value associated with a notification. Notification is sent when the cost exceeded the threshold. It is always percent and has to be between 0 and 1000. Defaults to 90.
    `threshold_type` - the type of threshold for the notification. This determines whether the notification is triggered by forecasted costs or actual costs. The allowed values are Actual and Forecasted. Default is Actual.
    For more information, please visit: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/consumption_budget_resource_group
    EOT
}

variable "default_consumption_budget_notification_emails" {
  type        = list(string)
  default     = []
  description = "List of e-mail addresses that will be used for notifications if they were not provided explicitly"
}
