terraform {
  required_version = ">= 0.12"
  required_providers {
    # random = {
    #   source  = "hashicorp/random"
    #   version = "~> 3.3.0"  # Updated version
    # }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.11.0"  # Updated version
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.61.0"  # Updated version (be cautious)
    }
    # local = {
    #   source  = "hashicorp/local"
    #   version = "~> 2.4.1"  # Updated version
    # }
    # null = {
    #   source  = "hashicorp/null"
    #   version = "~> 3.2.2"  # Updated version
    # }
    # cloudinit = {
    #   source  = "hashicorp/cloudinit"
    #   version = "~> 3.1.0"  # Updated version
    # }
  }

}
