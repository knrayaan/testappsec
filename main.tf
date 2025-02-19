
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}
provider "azurerm" {
  features {}
}

locals {
  resource_group="app-grp"
  location="North Europe"
}


resource "azurerm_resource_group" "app_grp"{
  name=local.resource_group
  location=local.location
}

resource "azurerm_storage_account" "functionstore_089889" {
  name                     = "functionstore089889"
  resource_group_name      = azurerm_resource_group.app_grp.name
  location                 = azurerm_resource_group.app_grp.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "function_app_plan" {
  name                = "function-app-plan"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  os_type             = "Linux" # Or "Windows" depending on your function app's needs
  sku_name            = "S1"
}



resource "azurerm_windows_function_app" "functionapp_1234000" {
  name                = "functionapp1234000"
  location            = azurerm_resource_group.app_grp.location
  resource_group_name = azurerm_resource_group.app_grp.name
  service_plan_id     = azurerm_service_plan.function_app_plan.id

  storage_account_name       = azurerm_storage_account.functionstore_089889.name
  storage_account_access_key = azurerm_storage_account.functionstore_089889.primary_access_key

  site_config {
    application_stack {
      dotnet_version = "v6.0"
    }
  }
}