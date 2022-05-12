resource "aws_s3_bucket" "terraform_s3" {
  bucket = local.s3_options.bucket_name

  tags = {
    Name        = local.s3_options.bucket_name
    Environment = local.s3_options.tag_environment
  }
}

resource "aws_s3_bucket_acl" "terraform_s3_bucket_acl" {
  bucket = aws_s3_bucket.terraform_s3.id
  acl    = local.s3_options.acl
}