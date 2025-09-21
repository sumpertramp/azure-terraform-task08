variable "name_prefix" {
  type        = string
  description = "Base name prefix"
  default     = "cmtr-vf06h1cc-mod8"
}


variable "location" {
  type        = string
  description = "Azure region"
  default     = "eastus"
}


variable "acr_sku" {
  type        = string
  description = "ACR SKU (Standard recommended for Tasks)"
  default     = "Standard"
}


variable "repo_url_with_deploy_token" {
  type        = string
  description = "Repository URL including deploy token, e.g. https://<user>:<token>@host/org/repo.git"
}


variable "git_pat" {
  type        = string
  description = "Git Personal Access Token used by ACR Task to access repository"
  sensitive   = true
}


variable "tags" {
  type = map(string)
  default = {
    Creator = "sumeyye_unal@epam.com"
  }
}
