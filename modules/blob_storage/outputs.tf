output "azurerm_storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.account.primary_blob_endpoint
}

output "azurerm_storage_account_primary_access_key" {
  value = azurerm_storage_account.account.primary_access_key
}
