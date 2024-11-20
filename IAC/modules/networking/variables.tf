variable "networking_variables" {
  type = map(object({
    vnet_name = string
    rg_name = string
    vnet_range = list(string)
    subnet_name = string
    subnet_range = list(string)
    pip_name = string
    windows_web_app_name = string
    app_gateway_name = string
    ip_config_name = string
  }))
}