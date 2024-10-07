# Static resource name instead of "var.name"
resource "aws_iam_role" "eks_node_group_role" {
  # Use var.name in the attribute instead of resource name
  name = "${var.name}-eks-node-group-nodes"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group_role.name
}

# Static resource name and corrected variable interpolation for cluster_name
resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name  # Correct var.name usage
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn

  subnet_ids = [
    aws_subnet.private_ap_south_1a.id,
    aws_subnet.private_ap_south_1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "sbrc-ai-services"
  }

  labels = {
    role = "sbrc-ai"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only_attachment,
  ]
}

# Static resource name and corrected variable interpolation for cluster_name
resource "aws_eks_node_group" "large_nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name  # Correct var.name usage
  node_group_name = "large-nodes"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn

  subnet_ids = [
    aws_subnet.private_ap_south_1a.id,
    aws_subnet.private_ap_south_1b.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3a.xlarge"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "marqo-db"
  }

  labels = {
    role = "marco"  
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only_attachment,
  ]
}
