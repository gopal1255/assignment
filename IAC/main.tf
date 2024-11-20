module "resoure_group" {
  source = "./modules/RG"
  rg_varibales = var.rg_varibales
}

module "database" {
  source = "./modules/db"
  sql_variables = var.sql_variables
  depends_on = [ module.resoure_group ]
}

module "webapp" {
  source = "./modules/webapp"
  web_app_variables = var.web_app_variables
  depends_on = [ module.database ]
}

module "networking" {
  source = "./modules/networking"
  networking_variables = var.networking_variables
  depends_on = [ module.webapp ]
}