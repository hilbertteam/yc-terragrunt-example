variable "folder_id" {
  type = string
}

variable "zone" {
  type    = string
  default = "ru-central1-a"
}

variable "subnets" {
  type = list(object({
    name = string
    cidr = string
    nat  = optional(bool, false)
    zone = optional(string, "ru-central1-b")
  }))
  default = []
}

variable "gw_ip_address" {
  description = "Custom gateway ip address"
  type        = string
  default     = null
}

variable "gateway" {
  type    = bool
  default = false
}

variable "vpc_id" {
  type = string
}
