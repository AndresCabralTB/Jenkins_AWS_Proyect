aws_account_id = "718254829448"
project_environment  = "test"

force_redeploy = false
backup_on_destroy = false
#force_destroy = false
enable_vpn = false
enable_cloudwatch_rule = false
desired_tasks = 1
jenkins_image_name = "jenkins-image-test-v2.580.2"
#garafana_image_name = ""
enable_garafana = false
allowed_hosts = ["177.240.126.203/32"]

BastionHostAMI = "bastionhost-ami-test"
PrivateHostAMI = "privatehost-ami-test"