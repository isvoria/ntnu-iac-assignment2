resource "azurerm_mssql_server" "server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "db" {
  name         = var.database_name
  server_id    = azurerm_mssql_server.server.id
  sku_name     = var.sku_name

  # change to 'true' to prevent accidental data loss
  lifecycle {
    prevent_destroy = false
  }
}
