provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "acceptanceTestResourceGroup1"
  location = var.location
}

resource "azurerm_sql_server" "example" {
  name                         = "cgoodleyqlserver"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
}

resource "azurerm_storage_account" "example" {
  name                     = "cgoodleysa"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "example" {
  name                = "cgoodleysqldatabase"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  server_name         = azurerm_sql_server.example.name

  extended_auditing_policy {
    storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.example.primary_access_key
    storage_account_access_key_is_secondary = true
    retention_in_days                       = 6
  }
}
