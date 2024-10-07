# Corrected to remove dynamic resource name
data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer  # Corrected var.name usage
}

# Static resource name and corrected variable interpolation for URL and thumbprint
resource "aws_iam_openid_connect_provider" "eks_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer  # Corrected var.name usage
}
