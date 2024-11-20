resource "azurerm_virtual_network" "vnet" {
  for_each = var.networking_variables
  name                = each.value.vnet_name
  location            = "eastus2"
  resource_group_name = each.value.rg_name
  address_space       = each.value.vnet_range
}

resource "azurerm_subnet" "subnet" {
  for_each = var.networking_variables
  name                 = each.value.subnet_name
  resource_group_name  = azurerm_virtual_network.vnet[each.key].resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet[each.key].name
  address_prefixes     = each.value.subnet_range
}

resource "azurerm_public_ip" "pip" {
  for_each = var.networking_variables
  name                = each.value.pip_name
  resource_group_name = each.value.rg_name
  location            = azurerm_virtual_network.vnet[each.key].location
  allocation_method   = "Static"
}

data "azurerm_windows_web_app" "windows_web_app" {
  for_each = var.networking_variables
  name                = each.value.windows_web_app_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_application_gateway" "app_gateway" {
  for_each = var.networking_variables
  name                = each.value.app_gateway_name
  resource_group_name = azurerm_virtual_network.vnet[each.key].resource_group_name
  location            = azurerm_virtual_network.vnet[each.key].location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = each.value.ip_config_name
    subnet_id = azurerm_subnet.subnet[each.key].id
  }

  frontend_port {
    name = "test-feport"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "test-feip"
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
  }

  backend_address_pool {
    name = "test-beap"
    fqdns =[data.azurerm_windows_web_app.windows_web_app[each.key].default_hostname]
  }

  backend_http_settings {
    name                  = "test-be-htst"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 60
  }

  http_listener {
    name                           = "test-httplstn"
    frontend_ip_configuration_name = "test-feip"
    frontend_port_name             = "test-feport"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "test-rqrt"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "test-httplstn"
    backend_address_pool_name  = "test-beap"
    backend_http_settings_name = "test-be-htst"
  }
}