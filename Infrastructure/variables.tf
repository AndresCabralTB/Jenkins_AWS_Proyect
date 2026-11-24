#==================================
# Essential Environment Variables
#==================================

variable "aws_account_id" {
  type      = string
  default   = ""
}

variable "project_environment" {
    type            = string 
    default         = "unknown"
    description     = "This is the environment control"
}

variable "project_version" {
    type            = string 
    default         = "unknown"
    description     = "This is the environment control"
}

variable "project_region" {
  type      = string
  default   = "us-east-1"
}

variable "workspace"{
  type      = string
  default   = "workspace"
}

#==================================
# Infrastructure Configuration Values
#==================================

variable "force_redeploy" {
    type        = bool
    default     = false
}

variable "force_destroy" {
    type        = bool
    default     = false
}

variable "backup_on_destroy" {
    type        = bool
    default     = true
}

variable "enable_ebs" {
    type = bool
    default = false
}

variable "deploy_private_resources"{
  type = bool
  default = true
}

variable "enable_vpn" {
  type      = bool 
  default   = false
}

variable "enable_cloudwatch_rule" {
  type      = bool
  default   = true
}
#==================================
# ECS Configuration Variables
#==================================

variable "desired_tasks"{
  type        = number
  default     = 0
  description = "Desired ECS Tasks deployed"
}

variable "jenkins_image_name" {
  type      = string
  default   = "unkown"
}

variable "garafana_image_name" {
  type      = string
  default   = "unkown"
}

variable "efs_id" {
  type      = string
  default   = "unkown"
}

variable "enable_garafana" {
  type      = string
  default   = "unkown"
}
#==================================
# EC2 Instances Configuration Variables
#==================================

variable "start_crontab" {
  type      = string
  default   = "cron(0 15 * * ? *)"
}

variable "stop_crontab" {
  type      = string
  default   = "cron(30 5 * * ? *)"
}

variable "BastionHostAMI" {
    type        = string
    default     = "Baseline-BastionHost-AMI"
}

variable "PrivateHostAMI" {
    type        = string
    default     = "Baseline-PrivateHost-AMI"
}

variable "allowed_hosts" {
  type          = list
  default       = [""]
  description   = "This is the Public IP for hosts allowed to ssh into the bastion host"
}
#==================================
# Database Configuration Variables
#==================================

# Pass the variables to an environment variable with:
# terraform TF_VAR_db_username="**********"
# terraform TF_VAR_db_password="**********"
variable "db_username" {
  description = "Database master username"
  type        = string
  sensitive   = true
  default     = "test_user" #Filler so that pipeline executes
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
  default     = "test_password" #Filler so that pipeline executes
}
