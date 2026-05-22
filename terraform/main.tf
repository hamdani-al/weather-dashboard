# ----------------------------------------------------------------
# Resource Group - a container that holds all our Azure resources
# ----------------------------------------------------------------
resource "azurerm_resource_group" "main" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = var.location

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ----------------------------------------------------------------
# Container Registry - private Docker registry to store our image
# ----------------------------------------------------------------
resource "azurerm_container_registry" "main" {
  name                = "${var.project_name}${var.environment}acr"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  admin_enabled       = true

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ----------------------------------------------------------------
# Container Instance - runs our Docker container with public IP
# ----------------------------------------------------------------
resource "azurerm_container_group" "main" {
  name                = "${var.project_name}-${var.environment}-aci"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "${var.project_name}-${var.environment}-${random_string.dns.result}"
  os_type             = "Linux"

  image_registry_credential {
    server   = azurerm_container_registry.main.login_server
    username = azurerm_container_registry.main.admin_username
    password = azurerm_container_registry.main.admin_password
  }

  container {
    name   = "weather-app"
    image = "${azurerm_container_registry.main.login_server}/weather-dashboard:${var.image_tag}"
    cpu    = "0.5"
    memory = "1.0"

    ports {
      port     = 5000
      protocol = "TCP"
    }

    secure_environment_variables = {
      WEATHER_API_KEY = var.weather_api_key
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# ----------------------------------------------------------------
# Random string - makes DNS label globally unique
# ----------------------------------------------------------------
resource "random_string" "dns" {
  length  = 6
  special = false
  upper   = false
}