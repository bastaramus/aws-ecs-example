# ------------ launch configuration ----------

resource "aws_launch_configuration" "ecs_lc" {
  name_prefix          = "ecs_lc-"
  image_id             = data.aws_ami.packer-ecs-cluster.id
  instance_type        = var.lc_instance_type
  security_groups      = ["${aws_security_group.ecs_ec2.id}"]
  key_name             = "dmitriy_khomenko_auth" #Already created
  iam_instance_profile = aws_iam_instance_profile.ecs_profile.id

  lifecycle {
    create_before_destroy = true
  }

}

# ------------ autoscaling group ----------

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "asg-${aws_launch_configuration.ecs_lc.id}"
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  health_check_grace_period = var.asg_grace
  health_check_type         = var.asg_hct
  desired_capacity          = var.asg_cap
  force_delete              = true
  #target_group_arns         = module.alb.target_group_arns

  vpc_zone_identifier = module.vpc.public_subnets

  launch_configuration = aws_launch_configuration.ecs_lc.name

  tag {
    key                 = "Name"
    value               = "ecs_instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "ecs-example"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    delete = "15m"
  }

}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.cluster_name
}

# ----------- Task definition ------------

resource "aws_ecs_task_definition" "wordpress" {
  family                = "wordpress"
  container_definitions = file("task-definitions/wordpress.json")
}

resource "aws_ecs_task_definition" "nginx" {
  family                = "nginx"
  container_definitions = file("task-definitions/nginx.json")
}

# -------------- Services -------------------

resource "aws_ecs_service" "wordpress" {
  name            = "wordpress"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 1

#  service_registries {
#    registry_arn = aws_service_discovery_service.wordpress.arn
#    container_name = "wordpress"
#    container_port = "9000"
#  }

}

resource "aws_ecs_service" "nginx" {
  name            = "nginx"
  cluster         = aws_ecs_cluster.ecs-cluster.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  iam_role        = aws_iam_role.svc.arn

  load_balancer {
    target_group_arn = module.alb.target_group_arns[0]
    container_name   = "nginx"
    container_port   = 80
  }

}

#-------- service discovery (we dont use it) ----------
resource "aws_service_discovery_private_dns_namespace" "wordpress" {
  name        = "ecs.local"
  description = "example"
  vpc         = module.vpc.vpc_id
}

resource "aws_service_discovery_service" "wordpress" {
  name = "wordpress"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.wordpress.id

    dns_records {
      ttl  = 10
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
