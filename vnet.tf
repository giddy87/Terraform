resource "azurerm_virtual_network" "virtual-terraform" {
name = "virtual-terraform"
resource_group_name = azurerm_resource_group.rg-test1.name
location = var.Location
address_space = ["10.10.0.0/16"]

subnet {
name = "production"
address_prefix = "10.10.0.0/24"
}
}

data "azurerm_subnet" "production" {
  name                 = "production"
  virtual_network_name = azurerm_virtual_network.virtual-terraform.name
  resource_group_name  = azurerm_resource_group.rg-test1.name
}

output "subnet_id" {
  value = data.azurerm_subnet.production.id
}



resource "azurerm_network_interface" "web_nic" {
count = var.nic_count
name = "web_nic${count.index}"
resource_group_name = azurerm_resource_group.rg-test1.name
location = var.Location
ip_configuration {
    name                          = "production"
    subnet_id                     = data.azurerm_subnet.production.id
    private_ip_address_allocation = "Dynamic"
  }

}
