data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_s3_read_policy" {
  statement {
    actions = ["s3:GetObject"]
    effect = "Allow"
    resources = ["arn:aws:s3:::${var.user_data_bucket_name}/*"]
  }
}

resource "aws_iam_role" "lambda_bucket_read_role" {
  name = "lambda_bucket_read_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json 
}


resource "aws_iam_policy" "lambda_bucket_read_role_policy" {
  name = "lambda_bucket_read_role_policy"
  policy = data.aws_iam_policy_document.lambda_s3_read_policy.json
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name = "bucket_read_policy_attachment"
  roles = [aws_iam_role.lambda_bucket_read_role.name]
  policy_arn = aws_iam_policy.lambda_bucket_read_role_policy.arn
}