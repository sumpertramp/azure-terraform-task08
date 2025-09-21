variable "name" {
  type        = string
  description = "Azure Cache for Redis kaynağı için temel ad/ön ek. İlgili adlandırmalarda kullanılacak."
}

variable "resource_group_name" {
  type        = string
  description = "Redis ve ilişkili kaynakların oluşturulacağı mevcut Azure Resource Group adı."
}

variable "location" {
  type        = string
  description = "Kaynakların dağıtılacağı Azure bölgesi (ör. eastus, westeurope)."
}

variable "capacity" {
  type        = number
  description = "Redis kapasite seviyesi (0–6 arası numerik değer). SKU'ya bağlı olarak bellek boyutunu belirler."
}

variable "sku_name" {
  type        = string
  description = "Redis SKU adı (örn. Basic, Standard, Premium, Enterprise/E10–E95 vb.)."
}

variable "family" {
  type        = string
  description = "Redis SKU ailesi (örn. C = Basic/Standard/Premium için, P = Premium için bazı bölgelerde)."
}

variable "kv_id" {
  type        = string
  description = "Gizli bilgileri saklamak için kullanılacak Azure Key Vault'un tam kaynak kimliği (resource ID)."
}

variable "redis_hostname_secret_name" {
  type        = string
  description = "Redis ana makine adı (hostname) için Key Vault üzerinde oluşturulacak/güncellenecek gizlinin adı."
}

variable "redis_primarykey_secret_name" {
  type        = string
  description = "Redis birincil erişim anahtarı (primary key) için Key Vault üzerinde oluşturulacak/güncellenecek gizlinin adı."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Azure kaynaklarına uygulanacak etiketler (anahtar/değer)."
}

