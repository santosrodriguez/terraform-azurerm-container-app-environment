# Azure Container App Environment Terraform Module

## Introduction
Deploy secure, production-ready Azure Container App Environment using Terraform.

## Usage

```hcl
locals {
  log_analytics_workspace_id = "/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/logs_rg/providers/Microsoft.OperationalInsights/workspaces/log-sharedsvcseastus"
  subnet_id = "/subscriptions/d745e6c8-c56c-4ade-812f-bfc262cc7a84/resourceGroups/Infrastructure_RG/providers/Microsoft.Network/virtualNetworks/vnet-cloudplat-eastus-sbx-01/subnets/general_subnet"
  infrastructure_subnet_id = "/subscriptions/d745e6c8-c56c-4ade-812f-bfc262cc7a84/resourceGroups/Infrastructure_RG/providers/Microsoft.Network/virtualNetworks/vnet-cloudplat-eastus-sbx-01/subnets/aca-test"
}

module "cae2" {
  source = "../../modules/containerAppEnvironment"
  #providers = {
  #  azurerm                            = azurerm
  # azurerm.CS-PNP-CommonServicesInfra = azurerm.CS-PNP-CommonServicesInfra
  #}
  subnet_id                = local.subnet_id
  infrastructure_subnet_id = local.infrastructure_subnet_id
  log_analytics_workspace_id = local.log_analytics_workspace_id
  resource_group_name      = azurerm_resource_group.rg.name
  location = "eastus"
  #infrastructure_resource_group_name = "MErg-santos-test"
  instance_number          = 1
  environment              = "dev"
  solution_name            = "santos"
  workload_profile = {
    name = "TestProfile"
    type = "D4"
    minimum_count = 0
    maximum_count = 2
  }
}

```

## Inputs

| Name                                | Type           | Description                                       | Default    |
|--------------------------------------|----------------|---------------------------------------------------|------------|
| dapr_application_insights_connection_string                  | string         | Resource group name                               | n/a        |
| environment                  | string         | Environment name                               | n/a        |
| identity_type                  | string         | Type of Identity to use                               | "SystemAssigned"        |
| infrastructure_subnet_id                  | string         | Subnet ID of the subnet to be used from the Infrastructure VNet                               | n/a        |
| instance_number                  | number         | Suffix for the instance number (01, 02, 03)                               | n/a        |
| internal_load_balancer_enabled                  | string         | Enable the internal load balancer                               | true        |
| location                  | string         | Location to deploy resources                               | "eastus"        |
| log_analytics_workspace_id                  | string         | ID of the log analytics workspace to send logs to                               | n/a        |
| logs_destination                  | string         | Resource group name                               | "log-analytics"        |
| public_network_access_enabled                  | bool         | Is public network access enabled?                               | false       |
| tags | map(string) | Tags to apply to resource | n/a |
| workload_profile | object | Type of container app workload profile to use | n/a |
| zone_redundancy_enabled | bool | Enable zone redundacy for this deployment | true |


## Outputs

| Name                                 | Description                           |
|--------------------------------------|---------------------------------------|
| container_app_environemt             | Container App Environment             |

## Features

- Secure, configurable container app environment
- Tagging support

## Requirements

- Terraform >= 1.4.0
- AzureRM >= 3.0
