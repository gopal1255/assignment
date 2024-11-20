output "webapp_hostname" {
  value = { for k, v in azurerm_windows_web_app.windows_web_app : k => {
    id                                = v.id
    default_hostname                  = v.default_hostname
    }
  }
}