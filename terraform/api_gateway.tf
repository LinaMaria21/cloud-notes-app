resource "aws_api_gateway_rest_api" "notes" {
  name = "${var.project_name}-api"
}

# /notes
resource "aws_api_gateway_resource" "notes" {
  rest_api_id = aws_api_gateway_rest_api.notes.id
  parent_id   = aws_api_gateway_rest_api.notes.root_resource_id
  path_part   = "notes"
}

# /notes/{id}
resource "aws_api_gateway_resource" "note_id" {
  rest_api_id = aws_api_gateway_rest_api.notes.id
  parent_id   = aws_api_gateway_resource.notes.id
  path_part   = "{id}"
}

locals {
  routes = {
    get_notes    = { resource = aws_api_gateway_resource.notes.id, method = "GET" }
    post_notes   = { resource = aws_api_gateway_resource.notes.id, method = "POST" }
    get_note     = { resource = aws_api_gateway_resource.note_id.id, method = "GET" }
    delete_note  = { resource = aws_api_gateway_resource.note_id.id, method = "DELETE" }
  }
}

resource "aws_api_gateway_method" "this" {
  for_each      = local.routes
  rest_api_id   = aws_api_gateway_rest_api.notes.id
  resource_id   = each.value.resource
  http_method   = each.value.method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "this" {
  for_each                = local.routes
  rest_api_id              = aws_api_gateway_rest_api.notes.id
  resource_id              = each.value.resource
  http_method              = aws_api_gateway_method.this[each.key].http_method
  integration_http_method  = "POST"
  type                     = "AWS_PROXY"
  uri                      = aws_lambda_function.notes.invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.notes.id

  triggers = {
    redeploy = sha1(jsonencode([
      aws_api_gateway_resource.notes.id,
      aws_api_gateway_resource.note_id.id,
      aws_api_gateway_method.this,
      aws_api_gateway_integration.this,
    ]))
  }

  depends_on = [aws_api_gateway_integration.this]
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.notes.id
  deployment_id = aws_api_gateway_deployment.this.id
  stage_name    = "Prod"
}
