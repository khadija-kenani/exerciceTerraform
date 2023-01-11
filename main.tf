provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "test" {
  name     = "test"
  location = "France Central"
}

resource "azurerm_virtual_network" "test" {
  name                = "test"
  resource_group_name = azurerm_resource_group.test.name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test.location
}

resource "azurerm_network_interface" "test" {
  name                = "test"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location

  ip_configuration {
    name                          = "config"
    subnet_id                     = azurerm_subnet.test.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "test2" {
  name                = "test2"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  ip_configuration {
    name                          = "config2"
    subnet_id                     = azurerm_subnet.test2.id
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_network_interface" "test3" {
  name                = "test3"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  ip_configuration {
    name                          = "config3"
    subnet_id                     = azurerm_subnet.test3.id
    private_ip_address_allocation = "dynamic"
  }
}


resource "azurerm_subnet" "test" {
  name                 = "test"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "test2" {
  name                 = "test2"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.6.0/24"]
}

resource "azurerm_subnet" "test3" {
  name                 = "test3"
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = ["10.0.7.0/24"]
}

resource "azurerm_virtual_machine" "test" {
  name                  = "vm"
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = [azurerm_network_interface.test.id]
  vm_size               = "Standard_b1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name          = "myosdisk1"
    vhd_uri       = "${azurerm_storage_account.test.primary_blob_endpoint}${azurerm_storage_container.test.name}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "khadija"
    admin_username = "khadijaVM"
    admin_password = "5kkgjfmgguf"
  }
}

resource "azurerm_virtual_machine" "test2" {
  name                  = "vm2"
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = [azurerm_network_interface.test2.id]
  vm_size               = "Standard_b1s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Nano-Server-Technical-Preview"
    version   = "latest"
  }

  storage_os_disk {
    name          = "myosdisk2"
    caching       = "ReadWrite"
    create_option = "FromImage"
    vhd_uri       = "${azurerm_storage_account.test.primary_blob_endpoint}${azurerm_storage_container.test.name}/myosdisk2.vhd"
  }

  os_profile {
    computer_name  = "khadija"
    admin_username = "khadijaVM2"
    admin_password = "fxuygompuipou8"
  }
}

resource "azurerm_virtual_machine" "test3" {
  name                  = "vm3"
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  network_interface_ids = ["${azurerm_network_interface.test3.id}"]
  vm_size               = "Standard_b1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name          = "myosdisk3"
    vhd_uri       = "${azurerm_storage_account.test.primary_blob_endpoint}${azurerm_storage_container.test.name}/myosdisk3.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "khadija"
    admin_username = "khadijaVM3"
    admin_password = "gjfkuyfyufl5"
  }
}
resource "azurerm_storage_account" "test" {
  name                     = "mpssrdsterraform"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "test" {
  name                  = "test"
  storage_account_name  = azurerm_storage_account.test.name
  container_access_type = "private"
}