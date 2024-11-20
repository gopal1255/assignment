data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "app_key_vault" {
  for_each            = var.web_app_variables
  name                = each.value.kv_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_service_plan" "service_plan" {
  for_each = var.web_app_variables
  name                = each.value.service_plan_name
  location            = "eastus2"
  resource_group_name = each.value.rg_name
  os_type             = "Windows"
  sku_name            = "P1v2"
}

resource "azurerm_user_assigned_identity" "uai" {
  for_each = var.web_app_variables
  location            = "eastus2"
  name                = each.value.uai_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_key_vault_access_policy" "access_policy" {
  for_each = var.web_app_variables
  key_vault_id = data.azurerm_key_vault.app_key_vault[each.key].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.uai[each.key].principal_id
  key_permissions = [
      "Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy",
    ]
    secret_permissions = [
     "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set",
    ]
}

data "azurerm_api_management_api" "api_management_api" {
  for_each            = { for k, v in var.web_app_variables : k => v if v.windows_web_app_api_management_api_name != null }
  name                = each.value.windows_web_app_api_management_api_name
  api_management_name = each.value.windows_web_app_api_management_name
  resource_group_name = each.value.rg_name
  revision            = each.value.windows_web_app_api_management_revision
}

resource "azurerm_windows_web_app" "windows_web_app" {
  for_each                           = var.web_app_variables
  name                               = each.value.windows_web_app_name
  location                           = "eastus2"
  resource_group_name                = each.value.rg_name
  service_plan_id                    = azurerm_service_plan.service_plan[each.key].id
  # dynamic "connection_string" {
  #   for_each = each.value.windows_web_app_connection_string != null ? each.value.windows_web_app_connection_string : {}
  #   content {
  #     name  = connection_string.value.connection_string_name
  #     type  = connection_string.value.connection_string_type
  #     value = connection_string.value.connection_string_value
  #   }
  # }
  dynamic "identity" {
    for_each = each.value.windows_web_app_identity != null ? [each.value.windows_web_app_identity] : []
    content {
      type = each.value.windows_web_app_identity.windows_web_app_identity_type
      identity_ids = each.value.windows_web_app_identity.windows_web_app_identity_type == "SystemAssigned, UserAssigned" || each.value.windows_web_app_identity.windows_web_app_identity_type == "UserAssigned" ? [azurerm_user_assigned_identity.uai[each.key].id] : null
    }
  }
  dynamic "site_config" {
    for_each = each.value.windows_web_app_site_config != null ? [each.value.windows_web_app_site_config] : []
    content {
      always_on                                     = site_config.value.site_config_always_on
      api_management_api_id                         = site_config.value.site_config_windows_web_app_is_api_management_api_required == true ? data.azurerm_api_management_api.api_management_api[each.key].id : null
        }
      }
}