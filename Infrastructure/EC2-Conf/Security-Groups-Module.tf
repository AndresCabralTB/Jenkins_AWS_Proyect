# Create the Security Groups
module "SecurityGroups_Module" {
  source                          = "./Security-Groups-Conf"
  vpc_id                          = var.vpc_id
  allowed_hosts                   = var.allowed_hosts
  TerraformDB_SecurityGroup_Id    = var.TerraformDB_SecurityGroup_Id
  project_environment             = var.project_environment
  deploy_private_resources        = var.deploy_private_resources
}
