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
  description = "A map of key to resource_name that will be used by tf-module-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
    region     = optional(string, "eastus2")
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    log_analytics_workspace = {
      name       = "law"
      max_length = 80
    }
  }
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

//firewall related variables
variable "firewall_map" {
  description = "Map of azure firewalls where name is key, and value is object containing attributes to create a azure firewall"
  type = map(object({
    logs_destinations_ids = list(string)
    subnet_cidr           = optional(string)
    additional_public_ips = optional(list(object(
      {
        name                 = string,
        public_ip_address_id = string
    })), [])
    application_rule_collections = optional(list(object(
      {
        name     = string,
        priority = number,
        action   = string,
        rules = list(object(
          { name             = string,
            source_addresses = list(string),
            source_ip_groups = list(string),
            target_fqdns     = list(string),
            protocols = list(object(
              { port = string,
            type = string }))
          }
        ))
    })))
    custom_diagnostic_settings_name = optional(string)
    custom_firewall_name            = optional(string)
    dns_servers                     = optional(string)
    extra_tags                      = optional(map(string))
    firewall_private_ip_ranges      = optional(list(string))
    ip_configuration_name           = optional(string)
    network_rule_collections = optional(list(object({
      name     = string,
      priority = number,
      action   = string,
      rules = list(object({
        name                  = string,
        source_addresses      = list(string),
        source_ip_groups      = optional(list(string)),
        destination_ports     = list(string),
        destination_addresses = list(string),
        destination_ip_groups = optional(list(string)),
        destination_fqdns     = optional(list(string)),
        protocols             = list(string)
      }))
    })))
    public_ip_zones = optional(list(number))
    sku_tier        = string
    zones           = optional(list(number))
  }))
  default = {}
}

//networking module related variables
variable "network_map" {
  description = "Map of spoke networks where vnet name is key, and value is object containing attributes to create a network"
  type = map(object({
    use_for_each    = bool
    address_space   = optional(list(string), ["10.0.0.0/16"])
    subnet_names    = optional(list(string), ["subnet1", "subnet2", "subnet3"])
    subnet_prefixes = optional(list(string), ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"])
    bgp_community   = optional(string, null)
    ddos_protection_plan = optional(object(
      {
        enable = bool
        id     = string
      }
    ), null)
    dns_servers                                           = optional(list(string), [])
    nsg_ids                                               = optional(map(string), {})
    route_tables_ids                                      = optional(map(string), {})
    subnet_delegation                                     = optional(map(map(any)), {})
    subnet_enforce_private_link_endpoint_network_policies = optional(map(bool), {})
    subnet_enforce_private_link_service_network_policies  = optional(map(bool), {})
    subnet_service_endpoints                              = optional(map(list(string)), {})
    tags                                                  = optional(map(string), {})
    tracing_tags_enabled                                  = optional(bool, false)
    tracing_tags_prefix                                   = optional(string, "")
  }))
}

//diagnotic setting module related variables
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

//log analytics module related variables
variable "log_analytics_destination_type" {
  type        = string
  description = "(Optional) Specifies the type of destination for the logs. Possible values are 'Dedicated' or 'Workspace'."
  default     = null
}

variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  description = "(Optional) A identity block as defined below."
  default     = null
}

variable "local_authentication_disabled" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether local authentication should be disabled. Defaults to false."
  default     = false
}

variable "sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 (new SKU as of 2018-04-03). Defaults to PerGB2018."
  default     = "Free"
}

variable "retention_in_days" {
  type        = number
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  default     = "30"
}
