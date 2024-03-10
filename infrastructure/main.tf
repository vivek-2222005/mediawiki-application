resource "azurerm_resource_group" "mediawiki-rg" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
  tags = {
    Environment = "${var.env}"
  }
}


resource "azurerm_virtual_network" "mediawiki-vnet" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.mediawiki-rg.location
  resource_group_name = azurerm_resource_group.mediawiki-rg.name
  address_space       = ["10.1.0.0/16"]
}


resource "azurerm_subnet" "mediawiki-snet" {
  name                 = "${var.prefix}-snet"
  virtual_network_name = azurerm_virtual_network.mediawiki-vnet.name
  resource_group_name  = azurerm_resource_group.mediawiki-rg.name
  address_prefixes     = ["10.1.0.0/22"]
}


resource "azurerm_kubernetes_cluster" "mediawiki-aks-cluster" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.mediawiki-rg.location
  resource_group_name = azurerm_resource_group.mediawiki-rg.name
  kubernetes_version  = var.aks_version
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name           = "system"
    node_count     = 1
    vm_size        = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.mediawiki-snet.id
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "${var.env}"
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "mediawiki-aks-np" {
  name                  = "aksnp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.mediawiki-aks-cluster.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.mediawiki-snet.id
  os_type               = "Linux"
  enable_auto_scaling   = "true"
  max_count             = 2
  min_count             = 1
  max_pods              = 15

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  tags = {
    Environment = "${var.env}"
  }
}