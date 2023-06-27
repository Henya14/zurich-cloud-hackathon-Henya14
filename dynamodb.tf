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

    attribute {
      name = "name"
      type = "S"
    }

    attribute {
      name = "surname"
      type = "S"
    }

    attribute {
      name = "birthdate"
      type = "S"
    }

    attribute {
      name = "address"
      type = "S"
    }

    attribute {
      name = "car"
      type = "S"
    }

    attribute {
      name = "fee"
      type = "N"
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

    attribute {
      name = "make"
      type = "S"
    }

    attribute {
      name = "model"
      type = "S"
    }

    attribute {
      name = "year"
      type = "N"
    }

    attribute {
      name = "color"
      type = "S"
    }

    attribute {
      name = "plate"
      type = "S"
    }

    attribute {
      name = "mileage"
      type = "N"
    }

    attribute {
      name = "fuelType"
      type = "S"
    }

    attribute {
      name = "transmission"
      type = "S"
    }

}