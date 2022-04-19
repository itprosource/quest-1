variable "name" {
  type = string
  description = ""
  default = ""
}

variable "cidr" {
  type = string
  description = ""
  default = ""
}

variable "public_subnets" {
  type = list(string)
  description = ""
  default = []
}

variable "private_subnets" {
  type = list(string)
  description = ""
  default = []
}

variable "azs" {
  type = list(string)
  description = ""
  default = []
}

variable "image" {
  type = string
  description = ""
  default = ""
}

variable "secret_name" {
  type = string
  description = ""
  default = ""
}

variable "secret_word" {
  type = string
  description = ""
  default = ""
  sensitive = true
}