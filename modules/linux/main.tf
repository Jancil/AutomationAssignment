resource "azurerm_availability_set" "avset" {
  name                         = var.linux_avset
  location                     = var.location
  resource_group_name          = var.resource_group
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true
  tags                         = local.common_tags
}

resource "azurerm_linux_virtual_machine" "vmlinux" {
  count                 = var.nb_count
  name                  = "${var.linux_name}${format("%1d", count.index + 1)}"
  location              = var.location
  resource_group_name   = var.resource_group
  network_interface_ids = [element(azurerm_network_interface.linux_nic[*].id, count.index + 1)]
  availability_set_id   = azurerm_availability_set.avset.id
  size                  = var.vm_size
  admin_username        = var.linux_admin_user

  depends_on = [azurerm_availability_set.avset]

  admin_ssh_key {
    username   = var.linux_admin_user
    public_key = file(var.pub_key)
  }

  os_disk {
    name                 = "${var.linux_name}-os-disk${format("%1d", count.index + 1)}"
    caching              = var.los_disk_attr["los_disk_caching"]
    storage_account_type = var.los_disk_attr["los_storage_account_type"]
    disk_size_gb         = var.los_disk_attr["los_disk_size"]
  }

  source_image_reference {
    publisher = var.linux_publisher
    offer     = var.linux_offer
    sku       = var.linux_sku
    version   = var.linux_version
  }

  boot_diagnostics {
    storage_account_uri = var.primaryendpoint
  }
  tags = local.common_tags

}

resource "azurerm_network_interface" "linux_nic" {
  count = var.nb_count
  name  = "${var.linux_name}-nic${format("%1d", count.index + 1)}"

  location            = var.location
  resource_group_name = var.resource_group

  ip_configuration {
    name                 = "${var.linux_name}-ip${format("%1d", count.index + 1)}"
    subnet_id            = var.subnet1_id
    public_ip_address_id = element(azurerm_public_ip.linux_pip[*].id, count.index)

    private_ip_address_allocation = "dynamic"
  }
  tags = local.common_tags
}

resource "azurerm_public_ip" "linux_pip" {
  count               = var.nb_count
  name                = "${var.linux_name}-pip${format("%1d", count.index + 1)}"
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.linux_name}${format("%1d", count.index + 1)}"
  tags                = local.common_tags
}
resource "azurerm_virtual_machine_extension" "extension" {
  count                      = var.nb_count
  name                       = "network-watcher"
  virtual_machine_id         = element(azurerm_linux_virtual_machine.vmlinux[*].id, count.index)
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_linux_virtual_machine.vmlinux]
  tags                       = local.common_tags
}
