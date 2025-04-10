data "aws_caller_identity" "current" {}

module "networking" {
  source        = "./modules/networking"
  stack_name    = "MyBase"
  template_path = "AWS_CF_Templates/networking.yml"
}

module "nat" {
  source        = "./modules/NAT"
  stack_name    = "NAT"
  template_path = "AWS_CF_Templates/NAT.yml"
  depends_on    = [module.networking]
}

module "rds" {
  source        = "./modules/RDS"
  stack_name    = "RDS"
  template_path = "AWS_CF_Templates/rds.yml"
  depends_on    = [module.networking]
}

module "efs" {
  source        = "./modules/EFS"
  stack_name    = "EFS"
  template_path = "AWS_CF_Templates/efs.yml"
  depends_on    = [module.networking]
}

module "s3athena" {
  source         = "./modules/S3Athena"
  stack_name     = "S3Athena"
  template_path  = "AWS_CF_Templates/bucket.yml"
  lab_account_id = data.aws_caller_identity.current.account_id
  depends_on     = [module.networking]
}

module "ecr" {
  source        = "./modules/ECR"
  stack_name    = "ECR"
  template_path = "AWS_CF_Templates/ecr.yml"
  depends_on    = [module.networking]
}

module "buildmaster" {
  source        = "./modules/buildInstance"
  stack_name    = "MasterBuild"
  template_path = "AWS_CF_Templates/buildMaster.yml"
  depends_on    = [module.networking, module.rds, module.s3athena, module.ecr, module.nat, aws_ssm_parameter.gcp_service_account]
}

resource "time_sleep" "wait_300s" {
  create_duration = "300s"
  depends_on      = [module.buildmaster]
}


module "appautoscaling" {
  source        = "./modules/WorkerInstances"
  stack_name    = "Instances"
  template_path = "AWS_CF_Templates/instances.yml"
  depends_on    = [time_sleep.wait_300s, module.efs]
}

module "monitoring" {
  source        = "./modules/Monitoring"
  stack_name    = "MonitoringInstance"
  template_path = "AWS_CF_Templates/MonitoringInstance.yml"
  depends_on    = [module.appautoscaling, module.networking, module.nat, module.efs]
}

resource "aws_ssm_parameter" "gcp_service_account" {
  name        = "/gcp/service-account/json"
  type        = "SecureString"
  value       = file("gcp-service-account.json")
  overwrite   = true  
}