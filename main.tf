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

# module "storageBucket" {
#   source  = "./modules/storageBucket"

#   buckets =   var.buckets
# }

module "cloudrun" {
  source     = "./modules/cloudRun"
  # project_id = var.project_id
  services   = var.cloudrun_services
}
