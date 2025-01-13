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

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnostic_setting" {
  name               = var.name
  target_resource_id = var.target_resource_id

  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type
  storage_account_id             = var.storage_account_id

  dynamic "enabled_log" {
    for_each = var.enabled_log != null ? var.enabled_log : []
    content {
      category       = enabled_log.value.category
      category_group = enabled_log.value.category_group
    }
  }

  dynamic "metric" {
    for_each = var.metric != null ? [var.metric] : []
    content {
      category = metric.value.category
      enabled  = metric.value.enabled
    }
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type] // The provider sees this as an "add" every time
  }
}
