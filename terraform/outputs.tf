output "app_url" {
  description = "Public URL to access the weather dashboard"
  value       = "http://${azurerm_container_group.main.fqdn}:5000"
}

output "resource_group" {
  value = azurerm_resource_group.main.name
}

output "container_registry" {
  value = azurerm_container_registry.main.login_server
}