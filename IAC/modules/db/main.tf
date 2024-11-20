data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  for_each = var.sql_variables
  name                        = each.value.kv_name
  location                    = "eastus2"
  resource_group_name         = each.value.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name = "standard"
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = each.value.user_object_id
    key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy",
    ]
    secret_permissions = [
     "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set",
    ]
    storage_permissions = [
      "Backup", "Delete", "DeleteSAS", "Get", "GetSAS", "List", "ListSAS", "Purge", "Recover", "RegenerateKey", "Restore", "Set", "SetSAS", "Update",
    ]
    certificate_permissions = [
        "Backup", "Create", "Delete", "DeleteIssuers", "Get", "GetIssuers", "Import", "List", "ListIssuers", "ManageContacts", "ManageIssuers", "Purge", "Recover", "Restore", "SetIssuers", "Update",
    ]
  }
}

# resource "azurerm_key_vault_secret" "kv_secret" {
#   for_each = var.sql_variables
#   name         = each.value.kv_secret_name
#   value        = "Azure@123456"
#   key_vault_id = azurerm_key_vault.kv[each.key].id
#   depends_on = [ azurerm_key_vault.kv ]
# }

resource "azurerm_mssql_server" "sql_server" {
  for_each = var.sql_variables
  name                         = each.value.sql_server_name
  resource_group_name          = each.value.rg_name
  location                     = "eastus2"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Azure@12345" #azurerm_key_vault_secret.kv_secret[each.key].value
  public_network_access_enabled = true
  depends_on = [ azurerm_key_vault.kv ]
}

resource "azurerm_mssql_database" "sql_db" {
  for_each = var.sql_variables
  name         = each.value.sql_db_name
  server_id    = azurerm_mssql_server.sql_server[each.key].id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  max_size_gb  = 2
  sku_name     = "S0"
  enclave_type = "VBS"
  read_scale = false
  zone_redundant = false
  depends_on = [ azurerm_mssql_server.sql_server ]
}