# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
  tags     = var.tags
}

# === Key Vault ===
module "keyvault" {
  source              = "./modules/keyvault"
  name                = local.keyvault_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  tags                = var.tags
}

# === Redis ===
module "redis" {
  source                       = "./modules/redis"
  name                         = local.redis_name
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  capacity                     = 2
  sku_name                     = "Basic"
  family                       = "C"
  kv_id                        = module.keyvault.id
  redis_hostname_secret_name   = local.redis_hostname_secret
  redis_primarykey_secret_name = local.redis_primarykey_secret
  tags                         = var.tags
}

# === ACR + Task ===
module "acr" {
  source                     = "./modules/acr"
  name                       = local.acr_name
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  sku                        = var.acr_sku
  repo_url_with_deploy_token = var.repo_url_with_deploy_token
  git_pat                    = var.git_pat
  image_name                 = local.image_name
  tags                       = var.tags
}

# === AKS ===
module "aks" {
  source              = "./modules/aks"
  name                = local.aks_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  node_size           = "Standard_D2ads_v5"
  node_count          = 1
  nodepool_name       = "system"
  os_disk_type        = "Ephemeral"
  acr_id              = module.acr.id
  keyvault_id         = module.keyvault.id
  tags                = var.tags
}

# === Configure providers from AKS outputs ===
provider "kubernetes" {
  host                   = module.aks.kube_config.host
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
}

provider "kubectl" {
  host                   = module.aks.kube_config.host
  cluster_ca_certificate = base64decode(module.aks.kube_config.cluster_ca_certificate)
  client_certificate     = base64decode(module.aks.kube_config.client_certificate)
  client_key             = base64decode(module.aks.kube_config.client_key)
  load_config_file       = false
}


data "azurerm_client_config" "current" {}

# === ACI (reads KV secrets via data) ===
data "azurerm_key_vault_secret" "redis_hostname" {
  name         = local.redis_hostname_secret
  key_vault_id = module.keyvault.id
  depends_on   = [module.redis]
}

data "azurerm_key_vault_secret" "redis_primarykey" {
  name         = local.redis_primarykey_secret
  key_vault_id = module.keyvault.id
  depends_on   = [module.redis]
}

module "aci" {
  source              = "./modules/aci"
  name                = local.aci_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  image               = "${module.acr.login_server}/${local.image_name}:latest"
  dns_name_label      = local.aci_dns_label
  registry_server     = module.acr.login_server
  registry_username   = module.acr.admin_username
  registry_password   = module.acr.admin_password
  tags                = var.tags


  env = {
    CREATOR        = "ACI"
    REDIS_PORT     = "6380"
    REDIS_SSL_MODE = "True"
  }


  secure_env = {
    REDIS_URL = data.azurerm_key_vault_secret.redis_hostname.value
    REDIS_PWD = data.azurerm_key_vault_secret.redis_primarykey.value
  }


  depends_on = [module.acr]
}


# === K8S SecretProviderClass + Secret + Deployment + Service ===
locals {
  spc_name             = "${var.name_prefix}-spc"
  workload_secret_name = "${var.name_prefix}-redis-secrets"
}

resource "kubectl_manifest" "spc" {
  yaml_body = templatefile("${path.module}/k8s-manifests/secret-provider.yaml.tftpl", {
    spc_name                = local.spc_name
    workload_secret_name    = local.workload_secret_name
    uami_client_id          = module.aks.uami_client_id
    keyvault_name           = module.keyvault.name
    tenant_id               = data.azurerm_client_config.current.tenant_id
    redis_hostname_secret   = local.redis_hostname_secret
    redis_primarykey_secret = local.redis_primarykey_secret
  })


  depends_on = [module.aks]
}


resource "kubectl_manifest" "deployment" {
  yaml_body = templatefile("${path.module}/k8s-manifests/deployment.yaml.tftpl", {
    name                 = var.name_prefix
    image                = "${module.acr.login_server}/${local.image_name}:latest"
    spc_name             = local.spc_name
    workload_secret_name = local.workload_secret_name
  })


  depends_on = [kubectl_manifest.spc]
}


resource "kubectl_manifest" "service" {
  yaml_body = templatefile("${path.module}/k8s-manifests/service.yaml", {
    name = var.name_prefix
  })


  depends_on = [kubectl_manifest.deployment]
}


# === Read back the Service to output the LB IP ===
data "kubernetes_service" "app_svc" {
  metadata { name = var.name_prefix }
  depends_on = [kubectl_manifest.service]
}