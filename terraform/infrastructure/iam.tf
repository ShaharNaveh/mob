resource "aws_iam_user" "cicd" {
  name = "cicd"
  path = "/"
}

resource "aws_iam_policy_attachment" "cicd" {
  name       = "CICDAttachment"
  users      = [aws_iam_user.cicd.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

data "aws_iam_policy_document" "websrv_ecr" {
  version = "2008-10-17"
  statement {
    sid    = "EcrReadWrite"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_user.cicd.arn]
    }

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]
  }
}
