# Azure Landing Zone Terraform Module

![Azure](https://img.shields.io/badge/azure-%230072C6.svg?style=for-the-badge&logo=microsoftazure&logoColor=white)
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)

![License](https://badgen.net/github/license/getindata/terraform-azurerm-landing-zone/)
![Release](https://badgen.net/github/release/getindata/terraform-azurerm-landing-zone/)

<p align="center">
  <img height="150" src="https://getindata.com/img/logo.svg">
  <h3 align="center">We help companies turn their data into assets</h3>
</p>

---

This module will create an Azure landing zone in the provided subscription.

An Azure landing zone is the output of a multi-subscription Azure environment that accounts for scale, security governance, networking, and identity.
An Azure landing zone enables application migration, modernization, and innovation at enterprise-scale in Azure. 
This approach considers all platform resources that are required to support the customer's application portfolio and doesn't differentiate between infrastructure as a service or platform as a service.

A landing zone is an environment for hosting your workloads, pre-provisioned through code. Watch the following video to learn more.

## USAGE

```terraform
module "landing_zone" {
  source = "github.com/getindata/terraform-azurerm-landing-zone"
  
  default_resource_group_location = "West Europe"
  resource_groups = {
    example-rg = {
      consumption_budgets = {
        default = {
          amount = 100
          time_period = {
            start_date = "2022-09-01T00:00:00Z"
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
```

### Resource groups
For more information, which options can be passed for `resource_groups` block, please visit <https://github.com/getindata/terraform-azurerm-resource-group>.

#### AD Groups

This module allows to create a set of Azure AD groups assigned to the resource group scope.

```terraform
resource_groups = {
  example = {
    ad_groups = {
      security-readers = {
        role_names = ["Security Reader"]
      }
    }
  }
}
```
The configuration above will create an AAD group named: `example-rg-security-readers`.
Users belonging to this group will have `Security Reader` role for the `example` resource group scope,
which means they will have this set of permissions to all child resources.

##### Default Azure AD groups
Instead of repeating the `ad_groups` block for each management unit, you can define a set of default AAD groups
that can be created for particular management units.

```terraform
default_ad_groups_for_resource_containers = {
  contributors = {
    role_names: ["Contributor"]
  }
  readers = {
    role_names: ["Reader"]
  }
}

resource_groups = {
  foo = {
    create_default_ad_groups = true
  }
  bar = {}
}
```
The configuration above will create an AAD groups named: `foo-rg-readers` and `foo-rg-contributors`,
but will not create any AD groups for the `bar` resource group.

The `default_ad_groups_for_resource_containers` option can be used in conjunction with the `ad_groups`,
where `ad_groups` takes a precedence if there's a group name conflict.

> The context object can drive the naming convention for the entire module, including the AAD groups naming.

## NOTES

At the moment this module supports only creating resource groups and related resources:
* consumption budgets
* AD groups
* custom IAM role assignments

In the future this module for Azure landing zone will support:
* Spoke VNET for Hub and Spoke architecture with peering
* Terraform state storage account
* Artifacts storage like Azure Container Registry
* Default KeyVault

## EXAMPLES

- [Simple landing zone with resource groups deployed to different locations](examples/simple)
- [Full example](examples/full-example)
- [Resource Groups with custom IAM role assignments](examples/resource-groups-with-iam-assignments)

<!-- BEGIN_TF_DOCS -->




## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br>This is for some rare cases where resources want additional configuration of tags<br>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br>in the order they appear in the list. New attributes are appended to the<br>end of the list. The elements of the list are joined by the `delimiter`<br>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "descriptor_formats": {},<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "labels_as_tags": [<br>    "unset"<br>  ],<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {},<br>  "tenant": null<br>}</pre> | no |
| <a name="input_default_ad_groups_for_resource_containers"></a> [default\_ad\_groups\_for\_resource\_containers](#input\_default\_ad\_groups\_for\_resource\_containers) | Map of default AD groups that will be created for resource groups if enabled | <pre>map(object({<br>    role_names : list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_default_consumption_budget_notification_emails"></a> [default\_consumption\_budget\_notification\_emails](#input\_default\_consumption\_budget\_notification\_emails) | List of e-mail addresses that will be used for notifications if they were not provided explicitly | `list(string)` | `[]` | no |
| <a name="input_default_resource_group_location"></a> [default\_resource\_group\_location](#input\_default\_resource\_group\_location) | Default Location for resource groups if not provided explicitly | `string` | `null` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br>Map of maps. Keys are names of descriptors. Values are maps of the form<br>`{<br>   format = string<br>   labels = list(string)<br>}`<br>(Type is `any` so the map values can later be enhanced to provide additional options.)<br>`format` is a Terraform format string to be passed to the `format()` function.<br>`labels` is a list of labels, in order, to pass to `format()` function.<br>Label values will be normalized before being passed to `format()` so they will be<br>identical to how they appear in `id`.<br>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for keep the existing setting, which defaults to `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br>Does not affect keys of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br>set as tag values, and output by this module individually.<br>Does not affect values of tags passed in via the `tags` input.<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br>Default is to include all labels.<br>Tags with empty values will not be included in the `tags` output.<br>Set to `[]` to suppress all generated tags.<br>**Notes:**<br>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br>  "default"<br>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br>This is the only ID element not also included as a `tag`.<br>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br>Characters matching the regex will be removed from the ID elements.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Map of resource groups and their configurations | `any` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | ./modules/resource-group | n/a |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_groups"></a> [resource\_groups](#output\_resource\_groups) | Outputs passed from the resource group module |

## Providers

No providers.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |

## Resources

No resources.
<!-- END_TF_DOCS -->

## CONTRIBUTING

Contributions are very welcomed!

Start by reviewing [contribution guide](CONTRIBUTING.md) and our [code of conduct](CODE_OF_CONDUCT.md). After that, start coding and ship your changes by creating a new PR.

## LICENSE

Apache 2 Licensed. See [LICENSE](LICENSE) for full details.

## AUTHORS

<!--- Replace repository name -->
<a href="https://github.com/getindata/terraform-azurerm-landing-zone/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=getindata/terraform-azurerm-landing-zone" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
