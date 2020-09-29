module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~>2.0"

  identifier = "wordpress-db"

  engine            = "mysql"
  engine_version    = "5.7.31"
  instance_class    = "db.t2.micro"
  allocated_storage = 20
  storage_encrypted = false

  name     = var.db_name
  username = var.db_username
  password = var.db_password
  port     = "3306"

  vpc_security_group_ids = ["${aws_security_group.DB_rds_sg.id}"]

  db_subnet_group_name = module.vpc.database_subnet_group

  family               = "mysql5.7"
  major_engine_version = "5.7"

  maintenance_window = "Mon:00:00-Mon:01:00"
  backup_window      = "01:00-02:00"

  deletion_protection = false

  tags = {
    Terraform   = "true"
    Project     = "ecs-example"
  }
}