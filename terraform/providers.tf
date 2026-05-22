terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateweatherkenwa1"
    container_name       = "tfstate"
    key                  = "weather-dashboard.tfstate"
    use_cli              = false
    use_msi              = false
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

  use_cli = false
  use_msi = false
}