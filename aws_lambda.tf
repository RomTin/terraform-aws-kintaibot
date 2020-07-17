/* ====================
Lambda function
==================== */

data "archive_file" "bot-pkg" {
  type        = "zip"
  output_path = "${path.module}/src/main.zip"
  source {
    content  = templatefile("${path.module}/src/main.py", {})
    filename = "main.py"
  }
}

resource "aws_lambda_function" "bot" {
  runtime                        = "python3.8"
  filename                       = data.archive_file.bot-pkg.output_path
  source_code_hash               = data.archive_file.bot-pkg.output_base64sha256
  function_name                  = "${var.id}-kintai-bot"
  layers                         = [aws_lambda_layer_version.layer.arn]
  handler                        = "main.handle"
  timeout                        = 60
  memory_size                    = 128
  reserved_concurrent_executions = -1
  role                           = aws_iam_role.bot-role.arn
  environment {
    variables = {
      slack_tokens            = join(";", var.slack_tokens)
      user_ids                = join(";", var.user_ids)
      destinations            = join(";", var.destinations)
      bucket_name             = aws_s3_bucket.timecards.bucket
      work_start_words        = join("|", var.work_start_words)
      work_start_text         = var.work_start_text
      work_start_res          = var.work_start_res
      remote_work_start_words = join("|", var.remote_work_start_words)
      remote_work_start_text  = var.remote_work_start_text
      remote_work_start_res   = var.remote_work_start_res
      work_end_words          = join("|", var.work_end_words)
      work_end_text           = var.work_end_text
      work_end_res            = var.work_end_res
      break_start_words       = join("|", var.break_start_words)
      break_start_text        = var.break_start_text
      break_start_res         = var.break_start_res
      afk_start_words         = join("|", var.afk_start_words)
      afk_start_text          = var.afk_start_text
      afk_start_res           = var.afk_start_res
      recover_words           = join("|", var.recover_words)
      recover_text            = var.recover_text
      recover_res             = var.recover_res
      broadcast_words         = join("|", var.broadcast_words)
      broadcast_res           = var.broadcast_res
      cancel_words            = join("|", var.cancel_words)
      cancel_text             = var.cancel_text
      cancel_res              = var.cancel_res
      undef_action_text       = join(";", var.undef_action_text)
      different_user          = join(";", var.different_user)
      illegal_action_text     = join(";", var.illegal_action_text)
    }
  }
}


/* ====================
Lambda Layer
==================== */

resource "aws_lambda_layer_version" "layer" {
  filename            = "${path.module}/src/dependencies.zip"
  source_code_hash    = filebase64sha256("${path.module}/src/dependencies.zip")
  layer_name          = "${var.id}-kintai-bot-layer"
  compatible_runtimes = ["python3.8"]
}
