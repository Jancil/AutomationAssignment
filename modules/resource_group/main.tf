resource "azurerm_resource_group" "rg" {
  name     = var.rg_common
  location = var.location
  tags     = local.common_tags
}
resource "azurerm_resource_group" "rg_network" {
  name     = var.rg_network
  location = var.location
  tags     = local.common_tags
}
