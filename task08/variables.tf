variable "name_prefix" {
  type        = string
  description = "Base name prefix for all resources (e.g., cmtr-vf06h1cc-mod8)"
  default     = "cmtr-vf06h1cc-mod8"
}

variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "eastus"
}

variable "acr_sku" {
  type        = string
  description = "ACR SKU (Standard required for ACR Tasks)"
  default     = "Standard"
}

# --- Primary (bizim orijinal) gizli değişkenler — BOŞ default ile ---
variable "repo_url_with_deploy_token" {
  type        = string
  description = "Repository URL including deploy token, e.g. https://<user>:<token>@host/org/repo.git"
  default     = "" # <- önemli
}

variable "git_pat" {
  type        = string
  description = "Git Personal Access Token used by ACR Task to access the repository"
  sensitive   = true
  default     = "" # <- önemli
}

# --- Verifier UI alias değişkenleri (panelden gelen isimler) ---
variable "repository_url_with_deploy_token" {
  type        = string
  description = "Alias accepted from the verifier UI for repository URL with deploy token"
  default     = ""
}

variable "git_personal_access_token" {
  type        = string
  description = "Alias accepted from the verifier UI for Git Personal Access Token"
  sensitive   = true
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Common tags to apply to all resources"
  default = {
    Creator = "sumeyye_unal@epam.com"
  }
}
