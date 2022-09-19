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

variable "default_consumption_budget_notification_emails" {
  type        = list(string)
  default     = []
  description = "List of e-mail addresses that will be used for notifications if they were not provided explicitly"
}
