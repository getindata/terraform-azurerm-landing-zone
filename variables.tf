variable "resource_groups" {
  type        = any
  description = "Map of resource groups and their configurations"
}

variable "default_ad_groups_for_resource_containers" {
  type = map(object({
    role_names : list(string)
  }))
  description = "Map of default AD groups that will be created for resource groups if enabled"
  default     = {}
}

variable "default_resource_group_location" {
  type        = string
  default     = null
  description = "Default Location for resource groups if not provided explicitly"
}

variable "default_consumption_budgets_notifications" {
  description = <<EOT
    Configuration of default notifications
    map(object({
      operator       = string
      threshold      = string
      threshold_type = string
      contact_emails = list(string)
    }))
  EOT
  type = map(object({
    operator       = string
    threshold      = string
    threshold_type = string
    contact_emails = list(string)
  }))
  default = {}
}

variable "default_consumption_budget_notification_emails" {
  description = "List of default e-mail addresses that will be used for notifications"
  type        = list(string)
  default     = []
}
