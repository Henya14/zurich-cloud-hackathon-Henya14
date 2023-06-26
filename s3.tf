resource "aws_s3_bucket" "user_data_bucket" {
  bucket = var.user_data_bucket_name
  
  tags = {
    name = var.user_data_bucket_name
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "user_data_bucket_encryption_config" {
  bucket = aws_s3_bucket.user_data_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
