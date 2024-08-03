module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"
  cluster_name    = var.eks_cluster_name
  cluster_version = var.kubernetes_version
  subnet_ids      = module.vpc.private_subnets

  tags = {
    cluster = "sock-shop-demo"
  }

  vpc_id = module.vpc.vpc_id

  eks_managed_node_group_defaults = {
    ami_type               = "AL2_x86_64"
    instance_types         = ["t3.medium"]
    vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }

  eks_managed_node_groups = {

    node_group = {
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
}


resource "null_resource" "kubectl" {
    provisioner "local-exec" {
        command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.eks_cluster_name}"
    }
}
