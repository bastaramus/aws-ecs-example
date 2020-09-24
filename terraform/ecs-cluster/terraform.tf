terraform {
  required_version = "~> 0.13.3"

  backend "s3" {
    bucket               = "aws-ecs-example-tfstate-storage-v1"
    dynamodb_table       = "aws-ecs-example-tf-lock-table"
    encrypt              = true
    key                  = "terraform.tfstate"
    region               = "eu-central-1"
    workspace_key_prefix = "ecs-cluster"
  }
}