variable "user_data_bucket_name" {
  type = string 
  description = "The name of the S3 bucket where the new user data is stored"
  default = "user-data-bucket"
}

variable "user_db_name" {
  type = string 
  description = "The name of the user dynamodb table"
  default = "user_table"
}

variable "aws_region" {
  type = string 
  description = "The region where the aws resources are"
  default = "us-east-1"
}
