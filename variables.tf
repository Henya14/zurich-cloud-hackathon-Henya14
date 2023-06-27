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

variable "car_db_name" {
  type = string 
  description = "The name of the car dynamodb table"
  default = "car_table"
}