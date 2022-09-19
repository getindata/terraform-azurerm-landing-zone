output "ad_groups" {
  description = "Map of AD Groups scoped to this Management Group"
  value       = module.ad_groups
}

output "iam_role_assignments" {
  description = "Map of IAM role assignments for the resource group scope"
  value       = local.iam_role_assignments
}

###################################################
## Downstream subscription module outputs
###################################################

output "id" {
  description = "The ID of the Resource Group"
  value       = module.this_resource_group.id
}

output "name" {
  description = "Name of the Resource Group"
  value       = module.this_resource_group.name
}

output "location" {
  description = "The Azure Region where the Resource Group should exist"
  value       = module.this_resource_group.location
}
