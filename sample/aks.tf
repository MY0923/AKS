# AKS
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.dns_prefix
  tags                = var.tags_def

  default_node_pool {
    name           = var.default_node_pool_name
    vm_size        = var.vm_size
    node_count     = var.node_count
    vnet_subnet_id = azurerm_subnet.internal.id
    type           = "VirtualMachineScaleSets"
    tags           = var.tags_def

    enable_auto_scaling = var.enable_auto_scaling
    max_count           = var.max_count
    min_count           = var.min_count
  }

  service_principal {
    client_id     = var.ARM_CLIENT_ID
    client_secret = var.ARM_CLIENT_SECRET
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_address
    service_cidr       = var.service_address
    load_balancer_sku  = "Standard"
  }

  lifecycle {
    prevent_destroy = true
  }
}
