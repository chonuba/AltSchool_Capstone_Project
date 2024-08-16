# Terraform configuration for EKS Cluster Creation

provider "aws" {
  region = "eu-north-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "sock-shop-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-north-1a", "eu-north-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway  = true
  enable_dns_hostnames = true
  #enable_dns_support   = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
} 
  
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

terraform {
    backend "s3" {
      bucket    = "sock-shop-eks-tf-20241408-state"
      key       = "sock-shop-eks/states"
      region    = "eu-north-1"
      #dynamodb_table = "value"
      encrypt   = true
    }
}

# Deploying EKS clusters...
terraform init
terraform apply -auto-approve 


# Update cluster kubeconfig file
aws eks update-kubeconfig --name sock-shop-eks --region eu-north-1

# Create namespace for the application depolyment
kubectl create namespace sock-shop

# Set default namesapce to sock-shop
kubectl config set-context --current --namespace=sock-shop

# Using locally created helm charts of the 
helm install sockapp ./k8/helm-charts/sock-shop-chart --namespace sock-shop

# Adding helm repositories required for the project..
helm repo add traefik https://helm.traefik.io/traefik
helm repo add jetstack https://charts.jetstack.io
helm repo update

# Installing traafik ingress controller
helm install traefik-ingress traefik/traefik

# Installing the ingress rule release
helm install ingress ingress-trfk --namespace sock-shop

# Installing cert-manager from jetstack helm chart.
helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.15.2 --set installCRDS=true

# Installing Certificate Issuer to get a TLS Certificate from Letsencrypt
helm install tls-cert ./k8s/helm-charts/tls-cert --namespace cert-manager

# Creating Monitoring namespace and Installing Prometheus and Grafana in it
helm install prome-grafana ./k8s/helm-charts/monitoring --namespace monitoring --create-namespace

# Installing prometheus node-exporters and grafana dash import after ensuring the pods are running...
helm upgrade prome-grafana ./k8s/helm-charts/monitoring-addons