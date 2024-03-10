terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "xxx"
    storage_account_name = "xxxxx"
    container_name       = "xxxxx"
    key                  = "xxxxx.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}
