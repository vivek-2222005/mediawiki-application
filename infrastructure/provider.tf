terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.95.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "aks-demo"
    storage_account_name = "mediawikistg"
    container_name       = "mediawiki-1"
    key                  = "mediawiki.terraform.tfstate"
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}