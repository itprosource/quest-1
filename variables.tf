variable "name" {
  type = string
  description = "Overarching name attached to all resources for identification purposes."
  default = ""
}

variable "cidr" {
  type = string
  description = "CIDR block for the VPC."
  default = ""
}

variable "public_subnets" {
  type = list(string)
  description = "CIDR blocks for public subnets."
  default = []
}

variable "private_subnets" {
  type = list(string)
  description = "CIDR blocks from private subnets."
  default = []
}

variable "azs" {
  type = list(string)
  description = "Availability Zones in which to deploy resources. Must be in the same region."
  default = []
}

variable "image" {
  type = string
  description = "Name of ECR image."
  default = ""
}
