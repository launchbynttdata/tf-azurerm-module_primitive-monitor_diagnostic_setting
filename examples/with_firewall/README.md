# tf-azurerm-module_primitive-monitor_diagnostic_setting

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.77 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_diagnostic_setting"></a> [diagnostic\_setting](#module\_diagnostic\_setting) | ../.. | n/a |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm | ~> 1.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 1.0 |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | terraform.registry.launch.nttdata.com/module_primitive/firewall/azurerm | ~> 1.0 |
| <a name="module_network"></a> [network](#module\_network) | terraform.registry.launch.nttdata.com/module_collection/virtual_network/azurerm | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>    region     = optional(string, "eastus2")<br>  }))</pre> | <pre>{<br>  "log_analytics_workspace": {<br>    "max_length": 80,<br>    "name": "law"<br>  },<br>  "resource_group": {<br>    "max_length": 80,<br>    "name": "rg"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"network"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_firewall_map"></a> [firewall\_map](#input\_firewall\_map) | Map of azure firewalls where name is key, and value is object containing attributes to create a azure firewall | <pre>map(object({<br>    logs_destinations_ids = list(string)<br>    subnet_cidr           = optional(string)<br>    additional_public_ips = optional(list(object(<br>      {<br>        name                 = string,<br>        public_ip_address_id = string<br>    })), [])<br>    application_rule_collections = optional(list(object(<br>      {<br>        name     = string,<br>        priority = number,<br>        action   = string,<br>        rules = list(object(<br>          { name             = string,<br>            source_addresses = list(string),<br>            source_ip_groups = list(string),<br>            target_fqdns     = list(string),<br>            protocols = list(object(<br>              { port = string,<br>            type = string }))<br>          }<br>        ))<br>    })))<br>    custom_diagnostic_settings_name = optional(string)<br>    custom_firewall_name            = optional(string)<br>    dns_servers                     = optional(string)<br>    extra_tags                      = optional(map(string))<br>    firewall_private_ip_ranges      = optional(list(string))<br>    ip_configuration_name           = optional(string)<br>    network_rule_collections = optional(list(object({<br>      name     = string,<br>      priority = number,<br>      action   = string,<br>      rules = list(object({<br>        name                  = string,<br>        source_addresses      = list(string),<br>        source_ip_groups      = optional(list(string)),<br>        destination_ports     = list(string),<br>        destination_addresses = list(string),<br>        destination_ip_groups = optional(list(string)),<br>        destination_fqdns     = optional(list(string)),<br>        protocols             = list(string)<br>      }))<br>    })))<br>    public_ip_zones = optional(list(number))<br>    sku_tier        = string<br>    zones           = optional(list(number))<br>  }))</pre> | `{}` | no |
| <a name="input_network_map"></a> [network\_map](#input\_network\_map) | Map of spoke networks where vnet name is key, and value is object containing attributes to create a network | <pre>map(object({<br>    use_for_each    = bool<br>    address_space   = optional(list(string), ["10.0.0.0/16"])<br>    subnet_names    = optional(list(string), ["subnet1", "subnet2", "subnet3"])<br>    subnet_prefixes = optional(list(string), ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"])<br>    bgp_community   = optional(string, null)<br>    ddos_protection_plan = optional(object(<br>      {<br>        enable = bool<br>        id     = string<br>      }<br>    ), null)<br>    dns_servers                                           = optional(list(string), [])<br>    nsg_ids                                               = optional(map(string), {})<br>    route_tables_ids                                      = optional(map(string), {})<br>    subnet_delegation                                     = optional(map(map(any)), {})<br>    subnet_enforce_private_link_endpoint_network_policies = optional(map(bool), {})<br>    subnet_enforce_private_link_service_network_policies  = optional(map(bool), {})<br>    subnet_service_endpoints                              = optional(map(list(string)), {})<br>    tags                                                  = optional(map(string), {})<br>    tracing_tags_enabled                                  = optional(bool, false)<br>    tracing_tags_prefix                                   = optional(string, "")<br>  }))</pre> | n/a | yes |
| <a name="input_enabled_log"></a> [enabled\_log](#input\_enabled\_log) | diagnotic setting module related variables | <pre>list(object({<br>    category_group = optional(string, null)<br>    category       = optional(string, null)<br>  }))</pre> | `null` | no |
| <a name="input_metric"></a> [metric](#input\_metric) | n/a | <pre>object({<br>    category = optional(string)<br>    enabled  = optional(bool)<br>  })</pre> | `null` | no |
| <a name="input_log_analytics_destination_type"></a> [log\_analytics\_destination\_type](#input\_log\_analytics\_destination\_type) | (Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'. | `string` | `null` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) A identity block as defined below. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_local_authentication_disabled"></a> [local\_authentication\_disabled](#input\_local\_authentication\_disabled) | (Optional) Boolean flag to specify whether local authentication should be disabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | (Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018. | `string` | `"Free"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730. | `number` | `"30"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The diagnostic settings ID. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The Workspace (or Customer) ID for the Log Analytics Workspace. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the Resource Group in which the Log Analytics Workspace is created. |
| <a name="output_diagnostic_setting_name"></a> [diagnostic\_setting\_name](#output\_diagnostic\_setting\_name) | The name of the diagnostic setting. |
| <a name="output_firewall_id"></a> [firewall\_id](#output\_firewall\_id) | The name of the diagnostic setting. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
