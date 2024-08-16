# terraform {
#     backend "s3" {
#       bucket    = "sock-shop-eks-tf-20241408-state"
#       key       = "sock-shop-eks/states"
#       region    = "eu-north-1"
#       #dynamodb_table = "terraform-lock"
#       encrypt   = true
#     }
# }