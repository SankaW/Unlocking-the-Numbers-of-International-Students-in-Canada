output "s3_bucket_name" {
  value = aws_s3_bucket.data_bucket.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.data_processing_lambda.function_name
}
