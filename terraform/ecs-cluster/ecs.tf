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

resource "aws_ecs_cluster" "ecs-cluster" {
  name = var.cluster_name
}