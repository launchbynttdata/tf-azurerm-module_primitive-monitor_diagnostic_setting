// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


module "diagnostic_setting" {
  source = "../.."

  name                           = local.diagnostic_setting_name
  target_resource_id             = local.firewall_id
  log_analytics_workspace_id     = module.log_analytics_workspace.id
  log_analytics_destination_type = var.log_analytics_destination_type
  enabled_log                    = var.enabled_log
  metrics                        = var.metrics
}

module "log_analytics_workspace" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm"
  version = "~> 1.0"

  name                          = local.log_analytics_workspace_name
  location                      = var.location
  resource_group_name           = module.resource_group.name
  sku                           = var.sku
  retention_in_days             = var.retention_in_days
  identity                      = var.identity
  local_authentication_disabled = var.local_authentication_disabled

  depends_on = [module.resource_group]
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 1.0"

  name     = local.resource_group_name
  location = var.location
  tags = {
    resource_name = local.resource_group_name
  }
}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 1.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.location))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}

module "firewall" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firewall/azurerm"
  version = "~> 1.0"

  firewall_map = local.firewall_map

  depends_on = [module.network, module.resource_group]
}

module "network" {
  source  = "terraform.registry.launch.nttdata.com/module_collection/virtual_network/azurerm"
  version = "~> 1.0"

  network_map = local.network_map
  depends_on  = [module.resource_group]
}
