module "ecr" {
  source = "../modules/ecr"
  name   = "websrv"
}

resource "aws_ecr_repository_policy" "websrv" {
  repository = module.ecr.name
  policy     = data.aws_iam_policy_document.websrv_ecr.json
}

resource "aws_iam_access_key" "cicd" {
  user = aws_iam_user.cicd.name
}

resource "aws_s3_object" "cicd_creds" {
  bucket = var.infrastructure_state_bucket
  key    = "artifacts/api.json"
  content = jsonencode({
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.cicd.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.cicd.secret
  })
}
