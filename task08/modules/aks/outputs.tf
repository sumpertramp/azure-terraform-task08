output "host" {
  value = data.azurerm_kubernetes_cluster.this.kube_config[0].host
}
output "cluster_ca_certificate" {
  value = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}
output "token" {
  value     = data.azurerm_kubernetes_cluster.this.kube_config[0].password
  sensitive = true
}
output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}

