/*
 "Terraform State Lock" but without the "Lock" part...

 Creating an S3 bucket to store all the tfstate files of this infra.

 Due to this being a home assignment I did not create things (to save the money) I would usually, such as:

 - Bucket versioning
 - Logs bucket
 - Server side encryption
 - Object Locking with S3 policies / DynamoDB
*/

resource "aws_s3_bucket" "tfstate" {
  bucket_prefix = "snaveh-mob"
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.tfstate.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
