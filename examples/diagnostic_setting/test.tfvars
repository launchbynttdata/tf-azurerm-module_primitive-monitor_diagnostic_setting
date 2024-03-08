logical_product_service = "gotest"
logical_product_family  = "launch"
class_env               = "sandbox"
instance_env            = 0
instance_resource       = 0
resource_names_map = {
  resource_group = {
    name       = "rg"
    max_length = 80
  }
  gotest_vnet = {
    name       = "vnet"
    max_length = 80
  }
  firewall = {
    name       = "fw"
    max_length = 80
  }
  firewall_policy = {
    name       = "fwplcy"
    max_length = 80
  }
  fw_plcy_rule_colln_grp = {
    name       = "fwplcyrulecollngrp"
    max_length = 80
  }
  public_ip = {
    name       = "pip"
    max_length = 80
  }
  gotest_vnet_ip_configuration = {
    name       = "ipconfig"
    max_length = 80
  }
  diagnostic_setting = {
    name       = "fwdiag"
    max_length = 80
  }
  log_analytics_workspace = {
    name       = "law"
    max_length = 80
  }
}
network_map = {
  "gotestnetwork" = {
    use_for_each    = false
    address_space   = ["10.0.0.0/16"]
    subnet_names    = []
    subnet_prefixes = []
  }
}
location = "eastus2"
firewall_map = {
  "gotestfirewall" = {
    logs_destinations_ids = []
    subnet_cidr           = "10.0.1.0/24"
    additional_public_ips = []
    sku_tier              = "Standard"
  }
}
sku = "PerGB2018"
enabled_log = [{
  category_group = "allLogs"
}]
log_analytics_destination_type = "Dedicated"
metric = {
  category = "allMetrics"
  enabled  = true
}
identity = {
  type = "SystemAssigned"
}
