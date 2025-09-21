variable "name" {
  type        = string
  description = "Kaynak(lar) için temel ad kökü. İlgili tüm isimlendirmelerde kullanılacak."
}

variable "resource_group_name" {
  type        = string
  description = "Kaynakların oluşturulacağı mevcut Azure Resource Group'un adı."
}

variable "location" {
  type        = string
  description = "Kaynakların dağıtılacağı Azure bölgesi (ör. eastus, westeurope)."
}

variable "image" {
  type        = string
  description = "Konteyner imajı tam adı (örn. myregistry.azurecr.io/app:tag)."
}

variable "dns_name_label" {
  type        = string
  description = "Genel uç nokta için DNS etiketi (ör. ACI/AKS LoadBalancer FQDN prefixi)."
}

variable "registry_server" {
  type        = string
  description = "Container Registry sunucu adresi (örn. myregistry.azurecr.io)."
}

variable "registry_username" {
  type        = string
  description = "Container Registry'e kimlik doğrulama için kullanıcı adı."
}

variable "registry_password" {
  type        = string
  sensitive   = true
  description = "Container Registry'e kimlik doğrulama için parola/erişim anahtarı."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Azure kaynaklarına uygulanacak etiketler (anahtar/değer)."
}

variable "env" {
  type        = map(string)
  default     = {}
  description = "Konteynere aktarılacak düz (gizli olmayan) ortam değişkenleri (KEY=VALUE)."
}

variable "secure_env" {
  type        = map(string)
  sensitive   = true
  default     = {}
  description = "Konteynere aktarılacak gizli ortam değişkenleri (parola, anahtar vb.). State dosyasında gizli tutulur."
}
