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
locals {
  resource_group_name          = module.resource_names["resource_group"].standard
  log_analytics_workspace_name = module.resource_names["log_analytics_workspace"].standard
  diagnostic_setting_name      = module.resource_names["diagnostic_setting"].standard
  virtual_network_name         = module.resource_names["gotest_vnet"].standard
  public_ip_custom_name        = module.resource_names["public_ip"].standard
  ip_configuration_name        = module.resource_names["gotest_vnet_ip_configuration"].standard

  firewall_id = module.firewall.firewall_ids["gotestfirewall"][0]

  location = var.location != null ? replace(trimspace(var.location), " ", "") : "eastus"

  network_map = {
    for key, value in var.network_map : key => merge(value, {
      resource_group_name = local.resource_group_name
      location            = var.location
      vnet_name           = local.virtual_network_name
    })
  }

  firewall_map = {
    for key, value in var.firewall_map : key => merge(value, {
      client_name           = var.logical_product_family
      stack                 = var.logical_product_service
      resource_group_name   = local.resource_group_name
      location              = local.location
      location_short        = local.location
      environment           = var.class_env
      vnet_name             = local.virtual_network_name
      ip_configuration_name = local.ip_configuration_name
      public_ip_name        = local.public_ip_custom_name
      virtual_network_name  = local.virtual_network_name
      public_ip_custom_name = local.public_ip_custom_name
    })

  }
}
