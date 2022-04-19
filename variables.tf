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