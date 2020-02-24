data "aws_region" "current" {}

data "aws_caller_identity" "me" {}

resource "aws_api_gateway_rest_api" "rest_api" {
  name = "${var.id}-kintai-bot-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  minimum_compression_size = -1
  api_key_source           = "HEADER"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_rest_api.rest_api.root_resource_id
  http_method             = aws_api_gateway_method.proxy.http_method
  content_handling        = "CONVERT_TO_TEXT"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.bot.invoke_arn
}

resource "aws_api_gateway_deployment" "apigw" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  stage_name  = "production"
  depends_on  = [aws_api_gateway_integration.lambda]
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.bot.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.me.account_id}:${aws_api_gateway_deployment.apigw.rest_api_id}/*/*/*"

}

output "api_url" {
  value       = aws_api_gateway_deployment.apigw.invoke_url
  description = "SlackAppのOutgoingWebhookに設定するAPIのURL"
}