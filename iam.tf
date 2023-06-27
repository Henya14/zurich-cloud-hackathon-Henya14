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

data "aws_iam_policy_document" "user_processor_lambda_role_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    effect = "Allow"
    resources = ["arn:aws:s3:::${var.user_data_bucket_name}/*"]
  }

  statement {
    actions = [ 
      "dynamodb:BatchWriteItem",
			"dynamodb:PutItem",
			"dynamodb:UpdateItem"
     ]
     effect = "Allow"
     resources = [aws_dynamodb_table.user_table.arn, aws_dynamodb_table.car_table.arn]
  }

  
}

resource "aws_iam_role" "user_processor_lambda_role" {
  name = "user_processor_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json 
}


resource "aws_iam_policy" "user_processor_lambda_role_policy" {
  name = "user_processor_lambda_role_policy"
  policy = data.aws_iam_policy_document.user_processor_lambda_role_policy_document.json
}

resource "aws_iam_policy_attachment" "policy_attachment" {
  name = "bucket_read_policy_attachment"
  roles = [aws_iam_role.user_processor_lambda_role.name]
  policy_arn = aws_iam_policy.user_processor_lambda_role_policy.arn
}