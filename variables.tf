variable "dapr_application_insights_connection_string" {
  type = string
  default = null
}

variable "environment" {
  type        = string
  description = "Deployment environment identifier (e.g. dev, int, crt, prod) used for naming and tagging."
  validation {
    condition = contains(
      ["dev", "int", "crt", "prd", "sbx", "spt"], var.environment
    )
    error_message = "Error: Environment is not valid. Valid options are dev, crt, sbx, int or prd."
  }
}

variable "identity_type" {
  type        = string
  default     = "SystemAssigned"
  description = "Managed identity type assigned to the Container Apps Environment. Supported value is 'SystemAssigned'."
}

variable "infrastructure_subnet_id" {
  type        = string
  description = "Subnet ID used for the Container Apps Environment infrastructure components (control plane). Must be delegated to Microsoft.Web/containerAppsEnvironments."
}

variable "internal_load_balancer_enabled" {
  type        = bool
  default     = true
  description = "Whether the Container Apps Environment uses an internal load balancer. When true, apps are only reachable from the virtual network."
}

variable "location" {
  type        = string
  description = "Azure region where the Container Apps Environment is deployed."

  validation {
    condition = contains(
      ["eastus", "westus", "northcentralus"], var.location
    )
    error_message = "Error: Location is not valid. Valid options are eastus, westus or northcentralus."
  }
}

variable "logs_destination" {
  type        = string
  default     = "log-analytics"
  description = "Destination for Container Apps logs. Currently supported value is 'log-analytics'."
}

variable "private_dns_zone_group_name" {
  type        = string
  default     = "default"
  description = "Name of the private DNS zone group associated with the Container Apps Environment private endpoint."
}

variable "private_dns_zone_ids" {
  type        = list(string)
  default     = ["/subscriptions/56bdaed4-70cf-4a28-8fb8-0efc135bb29f/resourceGroups/rg-azuredns-prd-01/providers/Microsoft.Network/privateDnsZones/privatelink.eastus.azurecontainerapps.io"]
  description = "List of private DNS zone IDs used for name resolution of the Container Apps Environment private endpoint."
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Whether public network access is allowed to the Container Apps Environment. When false, access is restricted to private networking."
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the Container Apps Environment is created."
}

variable  "log_analytics_workspace_id" {
  type = string
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID used by Container Apps for application ingress and runtime traffic. Must be delegated to Microsoft.Web/containerAppsEnvironments."
}

variable "solution_name" {
  type        = string
  description = "Logical solution or application name used for consistent resource naming."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to apply to the Container Apps Environment."
}

variable "workload_profile" {
  type = object({
    name           = string
    type           = string
    maximum_count  = optional(number)
    minimum_count  = optional(number)
  })
  description = "Custom workload profile definition for the Container Apps Environment, including profile name, SKU type, and optional scaling limits."
}

variable "zone_redundancy_enabled" {
  type        = bool
  default     = false
  description = "Whether zone redundancy is enabled for the Container Apps Environment. Requires a region that supports availability zones."
}
