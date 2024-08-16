# resource "aws_s3_bucket" "tfstates_bucket" {
#   bucket = "sock-shop-eks-tf-20241408-state"
  
#   lifecycle {
#     prevent_destroy = true
#   }
# }

# resource "aws_dynamodb_table" "terraform_lock" {
#   name           = "terraform-lock"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }