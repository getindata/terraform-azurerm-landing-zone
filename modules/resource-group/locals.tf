locals {
  ad_groups = merge(
    var.create_default_ad_groups ? var.default_ad_groups_for_resource_containers : {},
    var.ad_groups
  )
  iam_role_assignments = { for k, v in var.iam_role_assignments : k => {
    users  = try(v.users, [])
    groups = try(v.groups, [])
  } }
  #Flatten multidimensional maps into a flat map for iteration purposes
  iam_user_role_assignments = merge([for k, v in local.iam_role_assignments : { for user in v.users : "${k}-${user}" => {
    user      = user
    role_name = k
  } }]...)
  iam_group_role_assignments = merge([for k, v in local.iam_role_assignments : { for group in v.groups : "${k}-${group}" => {
    group     = group
    role_name = k
  } }]...)
}
