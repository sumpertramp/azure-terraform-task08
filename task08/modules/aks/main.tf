resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-dns"

  default_node_pool {
    name           = var.node_pool_name
    node_count     = var.node_count
    vm_size        = var.node_size
    os_disk_type   = "Ephemeral"
    vnet_subnet_id = null
  }

  identity {
    type = "SystemAssigned"
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }

  tags = var.tags
}

# AKS’in ACR’dan image çekebilmesi için AcrPull rolü
resource "azurerm_role_assignment" "acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# AKS’in KV’den secret okuyabilmesi için Access Policy
resource "azurerm_key_vault_access_policy" "aks_kv_policy" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

  secret_permissions = ["Get", "List"]
}

# Çıkışlar için kubeconfig parçaları
data "azurerm_kubernetes_cluster" "this" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = var.resource_group_name
}


