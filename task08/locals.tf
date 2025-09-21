locals {
  rg_name       = "${var.name_prefix}-rg"
  acr_name      = "${replace(var.name_prefix, "-", "")}cr" # cmtrvf06h1ccmod8cr
  keyvault_name = "${var.name_prefix}-kv"
  redis_name    = "${var.name_prefix}-redis"
  aci_name      = "${var.name_prefix}-ci"
  aks_name      = "${var.name_prefix}-aks"


  # DNS labels must be lowercase/alphanumeric/- and globally unique; best effort
  aci_dns_label = lower(replace(local.aci_name, "_", "-"))


  image_name = "${var.name_prefix}-app"


  # KV secret names
  redis_hostname_secret   = "redis-hostname"
  redis_primarykey_secret = "redis-primary-key"
}

locals {
  # Prefer explicit vars; fall back to verifier-provided aliases
  effective_repo_url = coalesce(
    var.repo_url_with_deploy_token,
    var.repository_url_with_deploy_token
  )

  effective_git_pat = coalesce(
    var.git_pat,
    var.git_personal_access_token
  )
}

