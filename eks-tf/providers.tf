provider "aws" {
  region = "eu-north-1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "sock_shop" {
  metadata {
    name = "sock-shop"
  }
}
