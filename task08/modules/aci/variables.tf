variable "name" {
  type        = string
  description = "Azure Container Instance (ACI) container group adı (örn. cmtr-vf06h1cc-mod8-ci)."
}

variable "location" {
  type        = string
  description = "ACI'nin oluşturulacağı Azure bölgesi (örn. eastus)."
}

variable "resource_group_name" {
  type        = string
  description = "ACI'nin yer alacağı Resource Group adı."
}

variable "tags" {
  type        = map(string)
  description = "Oluşturulan kaynağa uygulanacak ortak etiketler (örn. { Creator = \"sumeyye_unal@epam.com\" })."
}

variable "image" {
  type        = string
  description = "ACR içindeki tam imaj yolu (örn. cmtrvf06h1ccmod8cr.azurecr.io/cmtr-vf06h1cc-mod8-app:latest)."
}

variable "cpu" {
  type        = number
  default     = 1
  description = "Konteyner için vCPU sayısı."
}

variable "memory_gb" {
  type        = number
  default     = 1.5
  description = "Konteyner belleği (GB)."
}

# ACR kimlik bilgileri (image pull için)
variable "acr_server" {
  type        = string
  description = "ACR login server değeri (örn. cmtrvf06h1ccmod8cr.azurecr.io)."
}

variable "acr_username" {
  type        = string
  description = "ACR yönetici kullanıcı adı (admin_enabled=true ile alınır)."
}

variable "acr_password" {
  type        = string
  sensitive   = true
  description = "ACR yönetici parolası (gizli)."
}

# KV'den alınacak Redis secret değerleri (ACI'de secure env olarak kullanılacak)
variable "redis_hostname" {
  type        = string
  description = "Key Vault'taki 'redis-hostname' secret değeri (Redis host adı)."
}

variable "redis_primary_key" {
  type        = string
  sensitive   = true
  description = "Key Vault'taki 'redis-primary-key' secret değeri (Redis erişim anahtarı)."
}
