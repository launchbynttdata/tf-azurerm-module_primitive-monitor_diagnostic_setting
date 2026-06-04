<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.77, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.75.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_diagnostic_setting.monitor_diagnostic_setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | (Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_target_resource_id"></a> [target\_resource\_id](#input\_target\_resource\_id) | (Required) The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | (Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent. | `string` | `null` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | (Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'. | `string` | `null` | no |
| <a name="input_storage_account_id"></a> [storage\_account\_id](#input\_storage\_account\_id) | (Optional) Specifies the ID of a Storage Account where Diagnostics Data should be sent. | `string` | `null` | no |
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | n/a | <pre>list(object({<br/>    category_group = optional(string, null)<br/>    category       = optional(string, null)<br/>  }))</pre> | `null` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | (Optional) List of metrics and its properties. | <pre>list(object({<br/>    category = string<br/>    enabled  = optional(bool)<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Diagnostic Setting. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Diagnostic Setting. |
<!-- END_TF_DOCS -->
