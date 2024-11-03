# S3 Bucket for processed files
resource "aws_s3_bucket" "data_bucket" {
  bucket = var.bucket_name
  acl    = "private"
}

# Create "downloaded_files/" prefix by uploading an empty file
resource "aws_s3_object" "downloaded_files_placeholder" {
  bucket = aws_s3_bucket.data_bucket.bucket
  key    = "downloaded_files/placeholder.txt"
  content = ""
}

# Create "cleaned_files/" prefix by uploading an empty file
resource "aws_s3_object" "cleaned_files_placeholder" {
  bucket = aws_s3_bucket.data_bucket.bucket
  key    = "cleaned_files/placeholder.txt"
  content = ""
}