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

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Diagnostic Setting. Changing this forces a new resource to be created."
}

variable "target_resource_id" {
  type        = string
  description = "(Required) The ID of an existing Resource on which to configure Diagnostic Settings. Changing this forces a new resource to be created."
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "(Optional) Specifies the ID of a Log Analytics Workspace where Diagnostics Data should be sent."
  default     = null
}

variable "log_analytics_destination_type" {
  type        = string
  description = "(Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'."
  default     = null
}

variable "storage_account_id" {
  type        = string
  description = "(Optional) Specifies the ID of a Storage Account where Diagnostics Data should be sent."
  default     = null
}

variable "enabled_log" {
  type = list(object({
    category_group = optional(string, "allLogs")
    category       = optional(string, null)
  }))
  default = null
}

variable "metric" {
  type = object({
    category = optional(string)
    enabled  = optional(bool)
  })
  default = null
}
