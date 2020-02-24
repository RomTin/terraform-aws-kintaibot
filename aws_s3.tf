/* ====================
勤怠記録用S3バケット
==================== */

resource "aws_s3_bucket" "timecards" {
  bucket = "${var.id}-timecards"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "timecards-acl" {
  bucket                  = aws_s3_bucket.timecards.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [aws_s3_bucket.timecards]
}