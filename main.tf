terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  cloud {
    organization = "athome"
    workspaces {
      name = "quest-1"
    }
  }
}









