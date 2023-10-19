resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster"

  # create role iam

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

# attach the policy to the role


resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  role = aws_iam_role.eks_cluster.name

}


resource "aws_eks_cluster" "eks" {

  name = "eks"

  role_arn = aws_iam_role.eks_cluster.arn

  version = "1.24"

  vpc_config {

    endpoint_public_access = true

    endpoint_private_access = false

    subnet_ids = [
      var.sn_private_1_id,
      var.sn_private_2_id,
      var.sn_public_1_id,
      var.sn_public_2_id

    ]

  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]



}