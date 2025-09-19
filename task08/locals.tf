locals {
  rg_name         = "${var.name_prefix}-rg"
  acr_name        = replace("${var.name_prefix}cr", "-", "")
  aks_name        = "${var.name_prefix}-aks"
  aci_name        = "${var.name_prefix}-ci"
  kv_name         = "${var.name_prefix}-kv"
  redis_name      = "${var.name_prefix}-redis"
  image_name      = "${var.name_prefix}-app"
  aci_dns_label   = lower(replace(local.aci_name, "_", "-"))
  spc_name        = "mod8-spc"
  k8s_secret_name = "mod8-kv-secrets"

  redis_hostname_secret_name = "redis-hostname"
  redis_key_secret_name      = "redis-primary-key"
}
