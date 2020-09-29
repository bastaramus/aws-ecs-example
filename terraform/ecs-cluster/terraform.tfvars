aws_region = "eu-central-1"

vpc_cidr            = "10.10.0.0/16"
vpc_available_zones = ["eu-central-1a", "eu-central-1b"]
vpc_public_subnets  = ["10.10.11.0/24", "10.10.12.0/24"]
vpc_private_subnets = ["10.10.21.0/24", "10.10.22.0/24"]
vpc_db_subnets      = ["10.10.31.0/24", "10.10.32.0/24"]

cluster_name = "example-ecs-cluster"

lc_instance_type = "t3.medium"

asg_max             = "2"
asg_min             = "1"
asg_grace           = "300"
asg_hct             = "EC2"
asg_cap             = "1"