variable "aws_region" {
  description = "AWS Region"
  type = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket for storing processed files"
  default     = "my-data-pipeline-bucket"
}

variable "lambda_name" {
  description = "The name of the Lambda function"
  default     = "Data_Downloading_Lambda"
}

variable "lambda_name_cleaning_data" {
  description = "The name of the Lambda function"
  default     = "Data_cleaning_Lambda"
}

variable "lambda_role_name" {
  description = "The name of the IAM role for Lambda"
  default     = "lambda-execution-role"
}
