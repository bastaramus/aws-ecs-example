/****************************************
*************** INIT ********************
*****************************************/

resource "aws_dynamodb_table" "tf_lock_table" {
  name           = "aws-ecs-example-tf-lock-table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name    = "DynamoDB Terraform State Lock Table"
    Project = "aws-ecs-example"
  }
}

resource "aws_s3_bucket" "tfstate-storage-v1" {
  acl    = "private"
  bucket = "aws-ecs-example-tfstate-storage-v1"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name    = "S3 Remote Terraform State Store"
    Project = "aws-ecs-example"
  }
}