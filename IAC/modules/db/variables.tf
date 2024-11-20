variable "sql_variables" {
  type = map(object({
    sql_server_name = string
    sql_db_name = string
    rg_name = string
    kv_name = string
    user_object_id = string
    kv_secret_name = string
  }))
}
