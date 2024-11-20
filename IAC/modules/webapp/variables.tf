variable "web_app_variables" {
  type = map(object({
    service_plan_name = string
    windows_web_app_name = string
    rg_name = string
    kv_name = string
    uai_name = string
    windows_web_app_api_management_revision = string
    windows_web_app_api_management_name = string
    windows_web_app_api_management_api_name = string
    windows_web_app_identity = object({
      windows_web_app_identity_type = string
    })
      windows_web_app_site_config = object({
        site_config_always_on = bool
        site_config_windows_web_app_is_api_management_api_required = bool
    })
  }))
}
