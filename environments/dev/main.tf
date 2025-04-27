provider "azurerm" {
  features {}
}

module "vnet" {
  source              = "../../modules/vnet"
  vnet_name           = local.name_vnet
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]

  subnets = [
    {
      name              = "subnet-app"
      address_prefixes  = ["10.10.1.0/24"]
      service_endpoints = ["Microsoft.Storage"]
    }
  ]

  create_nsg             = true
  nsg_name               = local.name_nsg
  subnets_to_attach_nsg  = ["subnet-app"]
}

resource "azurerm_resource_group" "rg" {
  name     = local.name_rg
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_machine" "vm" {
  name                  = local.name_vm
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"

  # simplified for demo
  storage_os_disk {
    name              = "${local.name_vm}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "devvm"
    admin_username = "azureuser"
    admin_password = "ComplexPassw0rd!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = local.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "${local.name_vm}-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["subnet-app"]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_storage_account" "storage" {
  name                     = lower(replace("${var.env}-devstorage", "-", ""))
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}
