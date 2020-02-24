/* ====================
Lambda Layer
==================== */

data "archive_file" "zip_layer" {
  type        = "zip"
  source_dir  = "${path.module}/aws_lambda_src/layer/src"
  output_path = "${path.module}/aws_lambda_src/layer/layer.zip"
}

resource "aws_lambda_layer_version" "layer" {
  filename            = data.archive_file.zip_layer.output_path
  source_code_hash    = data.archive_file.zip_layer.output_base64sha256
  layer_name          = "${var.id}-kintai-bot-layer"
  compatible_runtimes = ["python3.7"]
}
