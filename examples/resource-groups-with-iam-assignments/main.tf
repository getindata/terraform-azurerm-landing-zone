module "this_landing_zone" {
  source  = "../../"
  context = module.this.context

  default_resource_group_location = "West Europe"
  resource_groups = {
    example-rg = {
      iam_role_assignments = {
        Contributor : {
          users : ["monica.smith@contoso.com"]
        }
        Reader : {
          groups : ["some_group_name_from_aad"]
        }
      }
    }
  }
}
