output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}
# output "tfstates_bucket_name" {
#   description = "Terraform state files storage bucket"
#   value = aws_s3_bucket.tfstates_bucket
# }
# output "cluster_security_group_id" {
#   description = "Security group ids attached to the cluster control plane."
#   value       = module.eks.cluster_security_group_id
# }

# output "region" {
#   description = "AWS region"
#   value       = var.aws_region
# }

# output "cluster_name" {
#   description = "Kubernetes Cluster Name"
#   value       = var.eks_cluster_name
# }
