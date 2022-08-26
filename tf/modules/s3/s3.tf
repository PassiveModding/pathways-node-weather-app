### Create Resources
resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}