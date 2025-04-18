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

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."

  validation {
    condition     = length(regexall("\\b \\b", var.location)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

//variables required by resource names module
variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
    region     = optional(string, "eastus2")
  }))
}

variable "instance_env" {
  type        = number
  description = "Number that represents the instance of the environment."
  default     = 0

  validation {
    condition     = var.instance_env >= 0 && var.instance_env <= 999
    error_message = "Instance number should be between 0 to 999."
  }
}

variable "instance_resource" {
  type        = number
  description = "Number that represents the instance of the resource."
  default     = 0

  validation {
    condition     = var.instance_resource >= 0 && var.instance_resource <= 100
    error_message = "Instance number should be between 0 to 100."
  }
}

variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "network"
}

variable "class_env" {
  type        = string
  description = "(Required) Environment where resource is going to be deployed. For example. dev, qa, uat"
  nullable    = false
  default     = "dev"

  validation {
    condition     = length(regexall("\\b \\b", var.class_env)) == 0
    error_message = "Spaces between the words are not allowed."
  }
}

//diagnotic setting module related variables
variable "enabled_log" {
  type = list(object({
    category_group = optional(string, null)
    category       = optional(string, null)
  }))
  default = null
}

variable "metrics" {
  description = "(Optional) List of metrics and its properties."
  type = list(object({
    category = optional(string)
    enabled  = optional(bool)
  }))
  default = []
}

//log analytics module related variables
variable "log_analytics_destination_type" {
  type        = string
  description = "(Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'AzureDiagnostics'."
  default     = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "(Optional) An identity with fields as defined here: https://www.terraform.io/docs/providers/azurerm/r/log_analytics_workspace.html"
  default     = null
}

variable "local_authentication_disabled" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether local authentication should be disabled. Defaults to false."
  default     = false
}

variable "sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. See https://learn.microsoft.com/en-us/azure/azure-monitor/cost-usage#moving-to-the-new-pricing-model. Defaults to PerGB2018."
  default     = "Free"
}

variable "retention_in_days" {
  type        = number
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  default     = "30"
}

//storage account module related variables
variable "linked_storage_account_data_source_type" {
  type        = string
  description = "(Required) The type of data source to be used for th linked storage accont."
  default     = "CustomLogs"
}
