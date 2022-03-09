resource "azurerm_log_analytics_workspace" "analytics" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resname
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
resource "azurerm_recovery_services_vault" "vault" {
  name                = var.vname
  location            = var.location
  resource_group_name = var.resname
  sku                 = "Standard"
  soft_delete_enabled = true
}
resource "azurerm_storage_account" "lrs_storage" {
  name                     = var.storageaccountname
  resource_group_name      = var.resname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
