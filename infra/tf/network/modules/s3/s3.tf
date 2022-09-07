#########################
## Create resources
#########################
resource "aws_s3_bucket" "this" {
  bucket = var.bucket
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

#########################
## Outputs
#########################

output "s3_bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "s3_bucket_arn" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.arn
}
