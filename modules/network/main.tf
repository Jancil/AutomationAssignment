resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet
  location            = var.location
  resource_group_name = var.rg_network
  address_space       = var.vnet_space
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet1
  resource_group_name  = var.rg_network
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet1_space
}

resource "azurerm_subnet" "subnet2" {
  name                 = var.subnet2
  resource_group_name  = var.rg_network
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet2_space
}

resource "azurerm_network_security_group" "nsg1" {
  name                = var.nsg1
  location            = var.location
  resource_group_name = var.rg_network

  security_rule {
    name                       = "rule1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
}
resource "azurerm_network_security_group" "nsg2" {
  name                = var.nsg2
  location            = var.location
  resource_group_name = var.rg_network
  security_rule {
    name                       = "rule1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }

  security_rule {
    name                       = "rule2"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5985"
    destination_address_prefix = "*"
    source_address_prefix      = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet_association1" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_subnet_network_security_group_association" "subnet_association2" {
  subnet_id                 = azurerm_subnet.subnet2.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}
