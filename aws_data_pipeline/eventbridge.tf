# eventbridge.tf
resource "aws_cloudwatch_event_rule" "monthly_schedule" {
  name                = "monthly_data_pipeline_schedule"
  schedule_expression = "cron(0 0 1 * ? *)"  # Runs the first day of every month
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule = aws_cloudwatch_event_rule.monthly_schedule.name
  arn  = aws_lambda_function.data_processing_lambda.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.data_processing_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.monthly_schedule.arn
}

#---------

# resource "aws_cloudwatch_log_group" "lambda_log_group" {
#   name = "/aws/lambda/${aws_lambda_function.data_processing_lambda.function_name}"
# }

# resource "aws_cloudwatch_log_subscription_filter" "lambda_success_filter" {
#   name            = "LambdaSuccessFilter"
#   log_group_name  = aws_cloudwatch_log_group.lambda_log_group.name
#   filter_pattern  = "{ $.status = \"OK\" }"
#   destination_arn = aws_lambda_function.data_cleaning_lambda.arn
# }

# resource "aws_lambda_permission" "allow_eventbridge_to_invoke" {
#   statement_id  = "AllowExecutionFromEventBridge"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.data_cleaning_lambda.function_name
#   principal     = "events.amazonaws.com"
#   source_arn    = aws_cloudwatch_log_subscription_filter.lambda_success_filter.arn
# }
