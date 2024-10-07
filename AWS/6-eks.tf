# Static resource name instead of "var.name"
resource "aws_iam_role" "eks_cluster_role" {  
  # Use the var.name in the attribute instead of the resource name
  name = "${var.name}-eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Static resource name instead of "var.name_amazon_eks_cluster_policy"
resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {  
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Static resource name instead of "var.name"
resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.name}-eks-cluster"   # Here you can use var.name in the attribute
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_ap_south_1a.id,
      aws_subnet.private_ap_south_1b.id,
      aws_subnet.public_ap_south_1a.id,
      aws_subnet.public_ap_south_1b.id
    ]
  }

  # Use the corrected resource reference name for the IAM role policy attachment
  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_attachment]
}
