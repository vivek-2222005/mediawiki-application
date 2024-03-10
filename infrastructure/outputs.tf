## client_certificate and kube_config are very sensitive and need to display in output if required nly

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.mediawiki-aks-cluster.kube_config[0].client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.mediawiki-aks-cluster.kube_config_raw

  sensitive = true
}