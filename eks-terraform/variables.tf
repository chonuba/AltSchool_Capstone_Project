variable "kubernetes_version" {
  default     = 1.30
  description = "kubernetes version"
}

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "default CIDR range of the VPC"
}
variable "aws_region" {
  default = "eu-north-1"
  description = "aws region"
}

variable "eks_cluster_name" {
  default = "sock-shop-eks"
  description = "Name of the EKS cluster"
}