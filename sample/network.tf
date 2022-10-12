// 仮想ネットワーク
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags_def
}

// サブネット
resource "azurerm_subnet" "internal" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address]
}
