resource "azurerm_postgresql_server" "server" {
  name                = "postgresqlserverjancil"
  location            = var.dblocation
  resource_group_name = var.dbname

  sku_name = "B_Gen5_2"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  administrator_login          = "n01459977"
  administrator_login_password = "HumberDragon79@"
  version                      = "9.5"
  ssl_enforcement_enabled      = true

}

resource "azurerm_postgresql_database" "database" {
  name                = "databasejancil"
  resource_group_name = var.dbname
  server_name         = azurerm_postgresql_server.server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"

}
