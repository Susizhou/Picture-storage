resource "aws_dynamodb_table" "terraform_lock" {
  hash_key       = "LockID"
  name           = "terraform_state"
  read_capacity  = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled = true
  }
}
