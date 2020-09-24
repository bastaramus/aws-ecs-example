module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  enable_dns_hostnames = true
  enable_dns_support   = true

  name = "aws-ecs-example_vpc"
  cidr = var.vpc_cidr

  azs              = var.vpc_available_zones
  private_subnets  = var.vpc_private_subnets
  public_subnets   = var.vpc_public_subnets
  database_subnets = var.vpc_db_subnets

  create_database_subnet_group = true

  public_subnet_tags = {
    Name = "public_subnet"
  }
  private_subnet_tags = {
    Name = "private_subnet"
  }
  database_subnet_tags = {
    Name = "db_subnet"
  }

  public_route_table_tags = {
    Name = "public_rt"
  }
  private_route_table_tags = {
    Name = "private_rt"
  }
  database_route_table_tags = {
    Name = "db_rt"
  }

  tags = {
    Terraform = "true"
    Project   = "aws-ecs-example"
  }

}