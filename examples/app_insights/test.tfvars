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
  log_analytics_workspace = {
    name       = "law"
    max_length = 80
  }
  application_insights = {
    name       = "ai"
    max_length = 80
  }
  diagnostic_setting = {
    name       = "ds"
    max_length = 80
  }
}
location = "eastus"
sku      = "PerGB2018"
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
