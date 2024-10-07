resource "aws_iam_role" "[var.name]" {
  name = "var.name"

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

resource "aws_iam_role_policy_attachment" "${var.name}_amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.${var.name}.name
}

resource "aws_eks_cluster" "${var.name}" {
  name     = "var.name"
  role_arn = aws_iam_role.${var.name}.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_ap_south_1a.id,
      aws_subnet.private_ap_south_1b.id,
      aws_subnet.public_ap_south_1a.id,
      aws_subnet.public_ap_south_1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.sbai_amazon_eks_cluster_policy]
}
