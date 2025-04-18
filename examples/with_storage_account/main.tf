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

  name                           = module.resource_names["diagnostic_setting"].standard
  target_resource_id             = module.application_insights.id
  log_analytics_workspace_id     = module.log_analytics_workspace.id
  log_analytics_destination_type = var.log_analytics_destination_type
  enabled_log                    = var.enabled_log
  metrics                        = var.metrics
  storage_account_id             = module.storage_account.id
}

module "log_analytics_workspace" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm"
  version = "~> 1.0"

  name                          = module.resource_names["log_analytics_workspace"].standard
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

  name     = module.resource_names["resource_group"].standard
  location = var.location
  tags = {
    resource_name = module.resource_names["resource_group"].standard
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

module "application_insights" {
  source                                = "terraform.registry.launch.nttdata.com/module_primitive/application_insights/azurerm"
  version                               = "~> 1.0"
  name                                  = module.resource_names["application_insights"].standard
  resource_group_name                   = module.resource_group.name
  application_type                      = "web"
  daily_data_cap_notifications_disabled = false
  disable_ip_masking                    = false
  workspace_id                          = module.log_analytics_workspace.id
  local_authentication_disabled         = true
  internet_ingestion_enabled            = true
  internet_query_enabled                = true
  force_customer_storage_for_profiler   = false

  location = var.location
  tags = {
    resource_name = module.resource_names["application_insights"].standard
    purpose       = "terratest"
  }
}

module "storage_account" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm"
  version = "~> 1.3"

  resource_group_name  = module.resource_group.name
  location             = var.location
  storage_account_name = module.resource_names["storage_account"].minimal_random_suffix_without_any_separators

  tags       = { purpose = "terratest" }
  depends_on = [module.resource_group]
}

module "linked_storage_account" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/log_analytics_linked_storage_account/azurerm"
  version = "~> 1.0"

  data_source_type      = var.linked_storage_account_data_source_type
  resource_group_name   = module.resource_group.name
  workspace_resource_id = module.log_analytics_workspace.id
  storage_account_ids   = [module.storage_account.id]
}
