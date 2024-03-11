terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }

  /*backend "azurerm" {
    resource_group_name  = "xxxxxx"
    storage_account_name = "xxxxxx"
    container_name       = "xxxxx"
    key                  = "xxxxxx"
  }*/
}

provider "azurerm" {
  # Configuration options
  features {}
}
