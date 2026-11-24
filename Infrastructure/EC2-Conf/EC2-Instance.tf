variable "project_environment" {
    type = string
}

variable "vpc_id" {
  type = string
}

variable "allowed_hosts" {
  type = list
}

#Get the subnet ID through a variable passed from the module calling
variable "subnet_A_id" {
  type = string
}

variable "subnet_B_id" {
  type = string
}

variable "TerraformDB_SecurityGroup_Id" {
  type = list
  default = [""]
}

variable "BastionHostAMI" {
    type = string
    default = "Baseline-BastionHost-AMI"
}

variable "PrivateHostAMI" {
    type = string
    default = "Baseline-PrivateHost-AMI"
}

variable "efs_system_id" {
    type = string
}

variable "deploy_private_resources"{
  type = bool
}


locals {
  BastionHost_InternalName  = "bastionhost.${var.project_environment}.cabral.cloud"
  PrivateHost_InternalName  = "privatehost.${var.project_environment}.cabral.cloud"
  BastionHost_Name          = "BastionHost-Terraform-${var.project_environment}"
  PrivateHost_Name          = "PrivateHost-Terraform-${var.project_environment}"
  mount_dir                 = "/mnt/efs"
}

/* #Retrieve the AMI for the bastion host
data "aws_ami" "bastion_ami" {
    #most_recent = true
    filter {
    name   = "tag:Name"                  # The tag key
    values = ["${var.BastionHostAMI}"]  # The tag value
  }
}

#Retrieve the AMI for the bastion host
data "aws_ami" "privatehost_ami" {
    #most_recent = true
    filter {
    name   = "tag:Name"                  # The tag key
    values = ["${var.PrivateHostAMI}"]  # The tag value
  }
} */

#Retrieve the EBS in order to attach it to the bastion host

/* data "aws_ebs_volume" "ebs_volume"{
  most_recent = true

  filter {
    name   = "tag:Name"
    values = ["ebs-bastion-host-${var.project_environment}"]
  }

} */

#Fetch the instance profile created in the bootstrap workspace
data "aws_iam_instance_profile" "BastionHostProfile" {
  name = "BastionHostProfile-${var.project_environment}"
}


resource "aws_instance" "BastionHost" {
    ami                         = "ami-0bbab131ebb18fcb4"
    /* launch_template{
      name = "BastionHost-LaunchTemplate-${var.project_environment}"
    } */
    associate_public_ip_address = true
    availability_zone           = "us-east-1a"
    iam_instance_profile        =  data.aws_iam_instance_profile.BastionHostProfile.name
    instance_type               = "t3.small"
    user_data_replace_on_change = true
    timeouts {
        create = "15m"  # Increases wait time to 15 minutes
      }
    #private_dns_name_options {
    #    enable_resource_name_dns_a_record   = true
    #    hostname_type                       = "resource-name"
    #}
    user_data = <<-EOF
        #!/bin/bash

        set -e
        MOUNT_DIR=${local.mount_dir}
        EFS_ID=${var.efs_system_id}

        mkdir -p "$MOUNT_DIR"
        chown 1000:1000 "$MOUNT_DIR"

        grep -q " $MOUNT_DIR " /etc/fstab || \
            echo "$EFS_ID:/ $MOUNT_DIR efs _netdev,tls,nofail,x-systemd.automount 0 0" >> /etc/fstab

        systemctl daemon-reload
        mount -a

        hostnamectl set-hostname ${local.BastionHost_InternalName}
    EOF

    vpc_security_group_ids      = [module.SecurityGroups_Module.BastionHostSecurityGroup_Id_Output]
    subnet_id                   = var.subnet_A_id

    root_block_device {
        delete_on_termination  = true
        volume_size = 15
        volume_type = "standard"

        tags = {
            Name = "bastion-host-root-block-device-${var.project_environment}"
        }
    }

    tags = {
      Name = local.BastionHost_Name
    }
}


resource "aws_instance" "PrivateHost" {
    ami                         = "ami-0bbab131ebb18fcb4"
   /*  launch_template{
      name = "BastionHost-LaunchTemplate-${var.project_environment}"
    } */
    availability_zone           = "us-east-1b"
    #iam_instance_profile        =  aws_iam_instance_profile.BastionHostProfile.name
    instance_type               = "t3.small"
    vpc_security_group_ids      = [module.SecurityGroups_Module.PrivateHostSecurityGroup_Id_Output]
    subnet_id                   = var.subnet_B_id
    count                       = var.deploy_private_resources ? 1 : 0
    timeouts {
        create = "15m"  # Increases wait time to 15 minutes
      }
    #private_dns_name_options {
    #    enable_resource_name_dns_a_record   = true
    #    hostname_type                       = "resource-name"
    #}
    user_data = <<-EOF
        #! /bin/bash
        hostnamectl set-hostname ${local.PrivateHost_InternalName}
    EOF
    tags = {
      Name = local.PrivateHost_Name
    }
}

# Bastion Host Outputs
output "BastionHost_Output_Id" {
  value = aws_instance.BastionHost.id
}

output "BastionHost_PrivateIp_Output" {
  value = aws_instance.BastionHost.private_ip
}

output "BastionHost_SecurityGroup_Id" {
  value = module.SecurityGroups_Module.BastionHostSecurityGroup_Id_Output
}

# Private Host Outputs
output "PrivateHost_Output_Id" {
  value = one(aws_instance.PrivateHost[*].id)
}

output "PrivateHost_PrivateIp_Output" {
  value = one(aws_instance.PrivateHost[*].private_ip)
}

output "PrivateHost_SecurityGroup_Id" {
  value = one(module.SecurityGroups_Module.PrivateHostSecurityGroup_Id_Output[*])
}

