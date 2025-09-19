data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

# Key Vault
module "keyvault" {
  source                 = "./modules/keyvault"
  name                   = local.kv_name
  location               = var.location
  resource_group_name    = azurerm_resource_group.rg.name
  tenant_id              = data.azurerm_client_config.current.tenant_id
  current_user_object_id = data.azurerm_client_config.current.object_id
  tags                   = var.tags
}

# Redis (+ secrets to KV)
module "redis" {
  source                     = "./modules/redis"
  name                       = local.redis_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tags                       = var.tags
  key_vault_id               = module.keyvault.id
  key_vault_name             = module.keyvault.name
  redis_hostname_secret_name = local.redis_hostname_secret_name
  redis_key_secret_name      = local.redis_key_secret_name

  depends_on = [module.keyvault]
}

# ACR + Task
module "acr" {
  source              = "./modules/acr"
  name                = local.acr_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
  sku                 = var.acr_sku

  git_repo_url = var.git_repo_url
  git_branch   = var.git_branch
  git_pat      = var.git_pat
  image_name   = local.image_name
}

# AKS (CSI driver enabled) + ACR Pull + KV access
module "aks" {
  source              = "./modules/aks"
  name                = local.aks_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
  acr_id              = module.acr.id
  key_vault_id        = module.keyvault.id
  tenant_id           = data.azurerm_client_config.current.tenant_id

  node_count     = 1
  node_size      = "Standard_D2ads_v5"
  node_pool_name = "system"

  depends_on = [module.acr, module.keyvault]
}

# ACI (image pulls from ACR, secrets from KV)
# KV'deki secret değerlerini Terraform ile oku
data "azurerm_key_vault_secret" "redis_hostname" {
  name         = local.redis_hostname_secret_name
  key_vault_id = module.keyvault.id
  depends_on   = [module.redis]
}
data "azurerm_key_vault_secret" "redis_key" {
  name         = local.redis_key_secret_name
  key_vault_id = module.keyvault.id
  depends_on   = [module.redis]
}

module "aci" {
  source              = "./modules/aci"
  name                = local.aci_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  dns_name_label    = local.aci_dns_label
  image             = "${module.acr.login_server}/${local.image_name}:latest"
  registry_server   = module.acr.login_server
  registry_username = module.acr.admin_user
  registry_password = module.acr.admin_pass

  redis_hostname = data.azurerm_key_vault_secret.redis_hostname.value
  redis_password = data.azurerm_key_vault_secret.redis_key.value

  depends_on = [module.acr, module.redis]
}

# ---- Providers (kubectl & kubernetes) AKS çıktısına dayalı ----
provider "kubectl" {
  host                   = module.aks.host
  cluster_ca_certificate = module.aks.cluster_ca_certificate
  token                  = module.aks.token
  load_config_file       = false
}

provider "kubernetes" {
  host                   = module.aks.host
  cluster_ca_certificate = module.aks.cluster_ca_certificate
  token                  = module.aks.token
}

# SecretProviderClass
resource "kubectl_manifest" "spc" {
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    spc_name                   = local.spc_name
    k8s_secret_name            = local.k8s_secret_name
    keyvault_name              = module.keyvault.name
    tenant_id                  = data.azurerm_client_config.current.tenant_id
    redis_hostname_secret_name = local.redis_hostname_secret_name
    redis_key_secret_name      = local.redis_key_secret_name
  })

  # Not: alekc/kubectl v2.1.3 için wait_for.fields desteklenmiyor.
  # SPC için wait_for BLOĞU KULLANMIYORUZ.
  depends_on = [module.aks, module.keyvault, module.redis]
}
# Deployment (image: ACR)
resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    spc_name                   = local.spc_name
    k8s_secret_name            = local.k8s_secret_name
    keyvault_name              = module.keyvault.name
    tenant_id                  = data.azurerm_client_config.current.tenant_id
    redis_hostname_secret_name = local.redis_hostname_secret_name
    redis_key_secret_name      = local.redis_key_secret_name
  })

  depends_on = [kubectl_manifest.spc, module.acr]
}

# Service
resource "kubectl_manifest" "service" {
  yaml_body = file("${path.module}/k8s-manifests/service.yaml")

  depends_on = [kubectl_manifest.deployment]
}

# AKS LoadBalancer IP (kubernetes provider datası)
data "kubernetes_service" "app_svc" {
  metadata {
    name = "mod8-app-svc"
  }
  depends_on = [kubectl_manifest.service]
}
