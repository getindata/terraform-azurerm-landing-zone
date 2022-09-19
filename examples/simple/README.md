# Full example

```terraform
module "this_landing_zone" {
  source  = "../../"
  context = module.this.context

  default_resource_group_location = "West Europe"
  resource_groups = {
    test-rg-1 = {}
    test-rg-2 = {
      location = "North Europe"
    }
    test-rg-3 = {}
  }
}
```

## Usage

```shell
terraform init
terraform plan -out tfplan
terraform apply tfplan
```
