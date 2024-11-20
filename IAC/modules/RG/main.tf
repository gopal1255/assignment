resource "azurerm_resource_group" "RG" {
  for_each = var.rg_varibales
  name     = each.value.rg_name
  location = "eastus2"
}