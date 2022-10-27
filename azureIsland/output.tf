# AKSクラスタのクライアント証明書を出力
output "client_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
}

# AKSクラスタのkubeconfigを出力
output "kube_config" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

# AKSクラスタのFQDNを出力
output "fqdn" {
  value = azurerm_kubernetes_cluster.this.fqdn
}

# AKSクラスタのIDを出力
output "cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}
