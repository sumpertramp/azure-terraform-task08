output "id" { value = azurerm_kubernetes_cluster.aks.id }
output "kube_config" {
  value     = module.aks.kube_config
  sensitive = true
}
