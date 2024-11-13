variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "Norway East"
}

variable "address_space" {
  type = list(string)
}

variable "subnet_prefixes" {
  type = list(string)
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "aps_sku" {
  type = string
}

variable "sql_sku" {
  type = string
}
