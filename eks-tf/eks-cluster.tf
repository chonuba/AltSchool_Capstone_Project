module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "sock-shop-eks"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  #control_plane_subnet_ids = ["subnet-xyzde987", "subnet-slkjf456", "subnet-qeiru789"]

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3.micro"]

  }

  eks_managed_node_groups = {
    sock-shop-nodes-1 = {
      name = "sock-shop-group-1"
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      # ami_type       = "AL2023_x86_64_STANDARD"
      # instance_types = ["t3.micro"]

      min_size     = 2
      max_size     = 4
      desired_size = 4
    }

    sock-shop-nodes-2 = {
      name = "sock-shop-group-2"

      min_size     = 2
      max_size     = 4
      desired_size = 4
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# resource "null_resource" "kubectl" {
#     provisioner "local-exec" {
#         command = "aws eks --region eu-north-1 update-kubeconfig --name sock-shop-eks"
#     }
# }