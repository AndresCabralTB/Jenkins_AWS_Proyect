resource "aws_launch_template" "BastionHost_LaunchTemplate" {
  name = "BastionHost-LaunchTemplate-${var.project_environment}"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true

  ebs_optimized = true

  iam_instance_profile {
    name = data.aws_iam_instance_profile.BastionHostProfile.name
  }
  image_id = "ami-096ef200a877f36af" #Default AWS Image
  instance_initiated_shutdown_behavior = "terminate"
  network_interfaces {
    associate_public_ip_address = true
  }

  placement {
    availability_zone = "us-east-1a"
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "BastionHost-${var.project_environment}"
    }
  }
}

#================================================================
#       PRIVATE HOST
#================================================================
resource "aws_launch_template" "Private_LaunchTemplate" {
  name = "PrivateHost-LaunchTemplate-${var.project_environment}"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_options {
    core_count       = 1
    threads_per_core = 1
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = true
  disable_api_termination = true
  ebs_optimized = true

  iam_instance_profile {
    name = data.aws_iam_instance_profile.BastionHostProfile.name
  }

  image_id = "ami-096ef200a877f36af" #Default AWS Image
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.small"

  network_interfaces {
    associate_public_ip_address = false
  }

  placement {
    availability_zone = "us-east-1a"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "PrivateHost-${var.project_environment}"
    }
  }
}


