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
      instance_types = ["t3.medium"]

  }

  eks_managed_node_groups = {
    sock-shop-nodes-1 = {
      name = "sock-shop-group-1"
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      # ami_type       = "AL2023_x86_64_STANDARD"
      # instance_types = ["t3.micro"]

      min_size     = 1
      max_size     = 4
      desired_size = 3
    }

    sock-shop-nodes-2 = {
      name = "sock-shop-group-2"

      min_size     = 1
      max_size     = 4
      desired_size = 3
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

resource "null_resource" "initial_setup" {
  provisioner "local-exec" {
    command = <<EOT
      aws eks update-kubeconfig --name sock-shop-eks --region eu-north-1
    EOT
  }

  depends_on = [module.eks]
}

resource "null_resource" "create_namespace" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl get namespace sock-shop || kubectl create namespace sock-shop
    EOT
  }

  depends_on = [null_resource.initial_setup]
}

resource "null_resource" "set_namespace" {
  provisioner "local-exec" {
    command = <<EOT
      kubectl config set-context arn:aws:eks:eu-north-1:533267405341:cluster/sock-shop-eks --namespace=sock-shop
    EOT
  }

  # depends_on = [null_resource.create_namespace]
}

# resource "null_resource" "initial_setup" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws eks update-kubeconfig --name sock-shop-eks --region eu-north-1
#       kubectl get namespace sock-shop || kubectl create namespace sock-shop
#       kubectl config set-context arn:aws:eks:eu-north-1:533267405341:cluster/sock-shop-eks --namespace=sock-shop

#     EOT
#   }

#   depends_on = [module.eks]
# }

# resource "null_resource" "initial_setup" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws eks update-kubeconfig --name sock-shop-eks --region eu-north-1
#       kubectl get namespace sock-shop || kubectl create namespace sock-shop
#       kubectl config set-context $(kubectl config current-context) --namespace=sock-shop

#     EOT
#   }

#   depends_on = [module.eks]
# }