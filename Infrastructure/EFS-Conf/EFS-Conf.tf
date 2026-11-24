variable "project_environment" {
    type = string
}

variable "subnet_A_id"{
    type = string
}

variable "BastionHost_SG_id"{
    type = string
}

data "aws_iam_role" "ecs-task-role"{
    name = "ecs-role-${var.project_environment}"
}

resource "aws_efs_file_system" "efs_system" {
  creation_token = "efs-docker-volumes-${var.project_environment}"
  encrypted = true

  tags = {
    Name = "efs-docker-volumes-${var.project_environment}"
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id    = aws_efs_file_system.efs_system.id
  subnet_id         = var.subnet_A_id
  security_groups   = ["${var.BastionHost_SG_id}"]
}

output "efs_system_id" {
    value = aws_efs_file_system.efs_system.id
}