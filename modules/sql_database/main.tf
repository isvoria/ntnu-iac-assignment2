resource "azurerm_mssql_server" "server" {
  name                          = var.sql_server_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.admin_username
  administrator_login_password  = var.admin_password
  public_network_access_enabled = false
  minimum_tls_version           = "1.2"
}

resource "azurerm_mssql_database" "db" {
  name      = var.database_name
  server_id = azurerm_mssql_server.server.id
  sku_name  = var.sku_name

  # change to 'true' to prevent accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}

resource "random_string" "random_string" {
  length  = 7
  special = false
  upper   = false
}

module "audit_storage" {
  source               = "../blob_storage"
  storage_account_name = "logauditokstorage${random_string.random_string.result}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  container_name       = "logauditokcontainer${random_string.random_string.result}"
}

resource "azurerm_mssql_server_extended_auditing_policy" "audit_policy" {
  server_id                               = azurerm_mssql_server.server.id
  storage_endpoint                        = module.audit_storage.azurerm_storage_account_primary_blob_endpoint
  storage_account_access_key              = module.audit_storage.azurerm_storage_account_primary_access_key
  storage_account_access_key_is_secondary = false
  retention_in_days                       = 90
}
