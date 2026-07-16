output "api_url" {
  value = "https://${aws_api_gateway_rest_api.notes.id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_stage.prod.stage_name}/notes"
}

output "table_name" {
  value = aws_dynamodb_table.notes.name
}

output "lambda_function_name" {
  value = aws_lambda_function.notes.function_name
}
