
data "archive_file" "lambda_code_zip" {
    type = "zip"
    source_dir = "./src"
    output_path = "code.zip"
}

resource "aws_lambda_function" "user_data_processor" {
  function_name = "user_data_processor"
  filename = "code.zip"
  source_code_hash = data.archive_file.lambda_code_zip.output_base64sha256
  role = aws_iam_role.lambda_bucket_read_role.arn
  runtime = "python3.10"
  handler = "user_data_processor.process_new_users"
  timeout = 200
}

resource "aws_lambda_permission" "allow_bucket_lambda_invocation" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_data_processor.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.user_data_bucket.arn
}


resource "aws_s3_bucket_notification" "s3_object_created_removed_lambda_trigger" {
  bucket = aws_s3_bucket.user_data_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.user_data_processor.arn
    events = ["s3:ObjectCreated:*"]
    filter_suffix  = ".json"
  }
  
  depends_on = [aws_lambda_permission.allow_bucket_lambda_invocation]
}