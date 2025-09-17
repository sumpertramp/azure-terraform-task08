variable "name" {
  type        = string
  description = "Bu modülün oluşturacağı kaynağın adı (modüle özgü)."
}

variable "location" {
  type        = string
  description = "Kaynağın oluşturulacağı Azure bölgesi (örn. eastus)."
}

variable "resource_group_name" {
  type        = string
  description = "Kaynağın yer alacağı Resource Group adı."
}

variable "tags" {
  type        = map(string)
  description = "Bu modülün oluşturduğu tüm kaynaklara uygulanacak ortak etiketler (örn. { Creator = \"sumeyye_unal@epam.com\" })."
}

