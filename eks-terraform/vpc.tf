provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "sock-shop-vpc"
  cidr                 = var.vpc_cidr

  azs                  = ["eu-north-1a", "eu-north-1b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}