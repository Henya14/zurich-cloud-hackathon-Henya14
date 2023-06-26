variable "user_data_bucket_name" {
  type = string 
  description = "The name of the S3 bucket where the new user data is stored"
  default = "user-data-bucket"
}
