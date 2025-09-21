resource "azurerm_kubernetes_cluster" "this" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  dns_prefix = var.name
  oidc_issuer_enabled = true


  default_node_pool {
    name = var.nodepool_name
    vm_size = var.node_size
    node_count = var.node_count
    os_disk_type = var.os_disk_type
    type = "VirtualMachineScaleSets"
    enable_auto_scaling = false
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


data "azurerm_client_config" "current" {}


# Allow AKS kubelet identity to pull from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope = var.acr_id
  role_definition_name = "AcrPull"
  principal_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}


# Allow AKS kubelet identity to get secrets from Key Vault (for CSI driver)
resource "azurerm_key_vault_access_policy" "aks_kv" {
  key_vault_id = var.keyvault_id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id


  secret_permissions = [
    "Get",
    "List"
  ]
}


