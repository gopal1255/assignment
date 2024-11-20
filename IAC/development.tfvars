rg_varibales = {
    "rg" = {
        rg_name = "testassignment"
    }
}

sql_variables = {
  "sql_1" = {
    sql_server_name = "testsqlsgopal1"
    sql_db_name = "testsqldb01"
    rg_name = "testassignment"
    kv_name = "testgopalkv45"
    rg_name = "testassignment"
    user_object_id = "c7a61c5e-a6ae-42a3-99b5-651e5d1e2c98"
    kv_secret_name = "sqladminpassword"
    
  }
}


web_app_variables = {
  "webapp_1" = {
    service_plan_name = "testplan01"
    windows_web_app_name = "testgopalassignapp01"
    rg_name = "testassignment"
    uai_name = "test223"
    kv_name = "testgopalkv45"
    windows_web_app_api_management_revision = "12"
    windows_web_app_api_management_name = "testapiam"
    windows_web_app_api_management_api_name = null
    windows_web_app_identity = {
      windows_web_app_identity_type = "SystemAssigned"
    }
    windows_web_app_site_config = {
              site_config_always_on = true
        site_config_windows_web_app_is_api_management_api_required = false
    }
  }
}


networking_variables = {
  "networking1" = {
    vnet_name = "testvnet1"
    rg_name = "testassignment"
    vnet_range = ["10.0.0.0/16"]
    subnet_name = "testsnet1"
    subnet_range = ["10.0.1.0/24"]
    pip_name = "testpip01"
    app_gateway_name = "testappgwt01"
    ip_config_name = "fep-config-01"
    windows_web_app_name = "testgopalassignapp01"
  }
}