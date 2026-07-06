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
  version = "~> 1.3"

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
  version = "~> 1.2"

  name     = local.resource_group_name
  location = var.location
  tags = {
    resource_name = local.resource_group_name
  }
}

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.4"

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

module "public_ip" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/public_ip/azurerm"
  version = "~> 2.0"

  name                = module.resource_names["public_ip"].standard
  resource_group_name = module.resource_group.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    resource_name = module.resource_names["public_ip"].standard
  }

  depends_on = [module.resource_group]
}

module "firewall" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/firewall/azurerm"
  version = "~> 2.1"

  name                = module.resource_names["firewall"].standard
  resource_group_name = module.resource_group.name
  location            = var.location
  sku_tier            = "Standard"
  private_ip_ranges   = try(one(values(local.firewall_map)).firewall_private_ip_ranges, null)

  ip_configuration = [{
    name                 = local.ip_configuration_name
    subnet_id            = module.network.subnet_name_id_map["AzureFirewallSubnet"]
    public_ip_address_id = module.public_ip.id
  }]

  depends_on = [module.network, module.resource_group, module.public_ip]
}

module "network" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/virtual_network/azurerm"
  version = "~> 3.2"

  resource_group_name = module.resource_group.name
  vnet_location       = var.location
  address_space       = coalesce(try(local.network.address_space, null), ["10.0.0.0/16"])
  vnet_name           = local.virtual_network_name
  subnets = coalesce(try(local.network.subnets, null), {
    AzureFirewallSubnet = {
      prefix = "10.0.1.0/24"
    }
  })

  depends_on = [module.resource_group]
}
