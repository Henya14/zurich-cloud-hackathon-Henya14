resource "aws_dynamodb_table" "user_table" {
    name = var.user_db_name
    billing_mode = "PROVISIONED"
    read_capacity = 20
    write_capacity = 20
    hash_key = "id"

    attribute {
      name = "id"
      type = "S"
    }
}


resource "aws_dynamodb_table" "car_table" {
    name = var.car_db_name
    billing_mode = "PROVISIONED"
    read_capacity = 5
    write_capacity = 5
    hash_key = "id"

    attribute {
      name = "id"
      type = "S"
    }
}