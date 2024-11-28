provider "aws" {
  region = "us-east-1"
}
# EKS cluster
resource "aws_eks_cluster" "my-eks" {
  name     = "my-cluster" 
  role_arn = aws_iam_role.eks-cluster.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.private-a.id,
      aws_subnet.private-b.id
    ]
  }

}

# Permissions 
resource "aws_iam_role" "eks-cluster" {
  # role policy for EKS service access
}

resource "aws_vpc" "eks-vpc" {
  # networking config  
}

resource "aws_subnet" "private-a" {
  # private subnet A
}

resource "aws_subnet" "private-b" {  
  # private subnet B
}
node-group.tf
# MANAGED NODE GROUP 
resource "aws_eks_node_group" "demo-ng" {   
  cluster_name = aws_eks_cluster.my-eks.name

  node_group_name = "managed-ondemand"
  instance_types = ["t3.medium"]

  subnet_ids = [
    aws_subnet.private-a.id
  ]
  
  # launch template configs
  # update policy etc  
}
