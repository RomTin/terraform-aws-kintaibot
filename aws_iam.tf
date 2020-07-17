/* ====================
IAM Role
==================== */
resource "aws_iam_role" "bot-role" {
  name               = "${var.id}-kintai-bot-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.bot-assume-policy-doc.json
}

resource "aws_iam_role_policy" "bot-iam-policy" {
  name   = "${var.id}-kintai-bot-policy"
  role   = aws_iam_role.bot-role.name
  policy = data.aws_iam_policy_document.bot-iam-policy-doc.json
}

data "aws_iam_policy_document" "bot-assume-policy-doc" {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "bot-iam-policy-doc" {
  version = "2012-10-17"
  statement {
    sid       = "${var.id}S3"
    effect    = "Allow"
    resources = [aws_s3_bucket.timecards.arn, "${aws_s3_bucket.timecards.arn}/*"]
    actions   = ["s3:ListBucket", "s3:*Object"]
  }
  statement {
    sid       = "${var.id}CloudWatch"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["logs:*"]
  }
}
