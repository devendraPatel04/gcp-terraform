# module "network" {
#   source = "./modules/network"

#   vpcs          = var.vpcs
#   subnets       = var.subnets
#   routes        = var.routes
#   firewallrules = var.firewallrules
# }


# module "compute" {
#   source = "./modules/compute"

#   instances = var.instances

#   networks = module.network.vpc_networks
#   subnets  = module.network.subnets
# }

module "storageBucket" {
  source  = "./modules/storageBucket"

  buckets =   var.buckets
}

# module "cloudrun" {
#   source     = "./modules/cloudRun"
#   # project_id = var.project_id
#   services   = var.cloudrun_services
# }

##Done use it better use cloud runs
# module "appEngine" {
#   source    = "./modules/appEngine"

#   project_id = var.project_id
#   create_app_engine = var.create_app_engine
#   app_engine_location_id = var.app_engine_location_id
#   app_engine_services = var.app_engine_services
# }
