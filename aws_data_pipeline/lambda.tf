# First Lambda function: Data Downloading
resource "aws_lambda_function" "data_processing_lambda" {
  filename         = "lambda_function.zip"  
  function_name    = var.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("lambda_function.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }
}

# Second Lambda function: Data Cleaning
resource "aws_lambda_function" "data_cleaning_lambda" {
  filename         = "lambda_cleaning_function.zip"  
  function_name    = var.lambda_name_cleaning_data
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_cleaning_function.lambda_handler" 
  runtime          = "python3.10"
  timeout          = 30  
  source_code_hash = filebase64sha256("lambda_cleaning_function.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.data_bucket.bucket
    }
  }

  layers = ["arn:aws:lambda:us-east-1:336392948345:layer:AWSSDKPandas-Python310:21"] 
}

