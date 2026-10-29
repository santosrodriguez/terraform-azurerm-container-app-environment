output "container_app_environment_id" {
  value = azurerm_container_app_environment.app_env.id
}

output "container_app_environment_identity_principal_id" {
  value = azurerm_container_app_environment.app_env.identity[0].principal_id
}
