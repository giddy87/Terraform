resource "azurerm_resource_group" "rg-test1" {
  name     = "rg-test1"
  location = var.Location
}

resource  "azurerm_virtual_machine" "web_server" {
count = var.instance_count
name = "Linux-${count.index}"
vm_size = "Standard_B1S"
location = var.Location
resource_group_name = azurerm_resource_group.rg-test1.name
delete_os_disk_on_termination = true

os_profile {
admin_username = "giddy"
admin_password = var.password 
computer_name = "Linux-${count.index}"
custom_data = file("install_apache.sh")
}

os_profile_linux_config {
    disable_password_authentication = false
}  

network_interface_ids = [element(azurerm_network_interface.web_nic.*.id, count.index)]

storage_os_disk {
    name = "myosdisk${count.index}"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
}

storage_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
}
tags = {
    Environment = "Testing"
}
}
