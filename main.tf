terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
  }
}

resource "random_string" "suffix" {
  length = 4
  upper = false
  special = false
  numeric = true
  lower = false
}

data "azurecaf_name" "app_env" {
  resource_type = "azurerm_container_app_environment"
  suffixes = [ var.solution_name, var.location, var.environment, random_string.suffix.result ]
}

resource "azurerm_container_app_environment" "app_env" {
  name = data.azurecaf_name.app_env.result
  location = var.location
  resource_group_name = var.resource_group_name
  dapr_application_insights_connection_string = var.dapr_application_insights_connection_string
  log_analytics_workspace_id = var.log_analytics_workspace_id
  public_network_access = "Disabled"
  infrastructure_subnet_id = var.infrastructure_subnet_id
  internal_load_balancer_enabled = var.internal_load_balancer_enabled
  mutual_tls_enabled = false
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
  zone_redundancy_enabled = var.zone_redundancy_enabled
  workload_profile {
    name = var.workload_profile.name
    workload_profile_type = var.workload_profile.type
    maximum_count = var.workload_profile.maximum_count
    minimum_count = var.workload_profile.minimum_count
  }
  lifecycle {
    ignore_changes = [ 
      name
    ]
  }
}

resource "azurerm_private_endpoint" "pep" {
  name = "pe-${azurerm_container_app_environment.app_env.name}"
  location = azurerm_container_app_environment.app_env.location
  resource_group_name = var.resource_group_name
  subnet_id = var.subnet_id
  private_service_connection {
    name = "connection-pe-${azurerm_container_app_environment.app_env.name}"
    is_manual_connection = false
    private_connection_resource_id = azurerm_container_app_environment.app_env.id
    subresource_names = ["managedEnvironments"]
  }
  private_dns_zone_group {
    name = var.private_dns_zone_group_name
    private_dns_zone_ids = var.private_dns_zone_ids
  }
}
