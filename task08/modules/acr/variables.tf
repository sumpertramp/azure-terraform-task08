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

variable "sku" {
  type        = string
  description = "Hizmet SKU değeri (ör. ACR için: Basic, Standard, Premium; diğer hizmetlerde ilgili SKU/Fiyatlandırma katmanı)."
}

variable "repo_url_with_deploy_token" {
  type        = string
  description = "İmajın kaynak kodunun bulunduğu depo URL'si. Erişim için gerekli deploy token içeren tam URL (örn. https://<token>@git.example.com/org/repo.git)."
  default     = ""
}

variable "git_pat" {
  type        = string
  sensitive   = true
  description = "Git deposuna erişim için kişisel erişim belirteci (Personal Access Token). Gizli tutulur."
  default     = ""
}

variable "image_name" {
  type        = string
  description = "Üretilecek/push edilecek konteyner imajının adı (örn. myapp veya myorg/myapp). Tag sürümü genelde derleme anında eklenir."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Azure kaynaklarına uygulanacak etiketler (anahtar/değer)."
}
