resource "azurerm_public_ip" "lb_ip" {
  name                = "PublicIPport"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = var.lb_frontend_ip_name
    public_ip_address_id = azurerm_public_ip.lb_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name                = var.lb_backend_pool_name
  loadbalancer_id     = azurerm_lb.lb.id
  resource_group_name = var.rg_name
}

resource "azurerm_network_interface_backend_address_pool_association" "linx_nic_backend_association" {
  ip_configuration_name   = "lb_ipconf"
  network_interface_id    = azurerm_network_interface.example.id
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = var.rg_name
  name                = var.lb_probe_name
  loadbalancer_id     = azurerm_lb.lb.id
  port                = var.port_ssh
}


resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.lb_rule_name
  protocol                       = "tcp"
  frontend_port                  = var.port_ssh
  backend_port                   = var.port_ssh
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_pool.id
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.lb_probe.id
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "lb_ipconf"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
