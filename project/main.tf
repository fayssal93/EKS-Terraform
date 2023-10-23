# configured aws provider with proper credentials
provider "aws" {
  profile = "default"
  region  = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.21"
    }
  }
}  

module "vpc" {
  source                    = "../modules/vpc"
  region                    = var.region  
  vpc_devops                = var.vpc_devops
  vpc_cidr                  = var.vpc_cidr
  sn_public_1_cidr          = var.sn_public_1_cidr
  sn_public_2_cidr          = var.sn_public_2_cidr
  sn_private_1_cidr         = var.sn_private_1_cidr 
  sn_private_2_cidr         = var.sn_private_2_cidr  
}

module "nat" {
  source                = "../modules/nat"
  sn_public_1_id        = module.vpc.sn_public_1_id
  sn_public_2_id        = module.vpc.sn_public_2_id
  rt_devops_private1_id = module.vpc.rt_devops_private1_id
  rt_devops_private2_id = module.vpc.rt_devops_private2_id
  rt_devops_public_id   = module.vpc.rt_devops_public_id
  internet_gateway_id   = module.vpc.internet_gateway_id

}
module "eks" {
  source = "../modules/eks"
  sn_private_1_id    = module.vpc.sn_private_1_id
  sn_private_2_id    = module.vpc.sn_private_1_id
  instance_type      = var.instance_type
  capacity_type      = var.capacity_type   
  ami_type           = var.ami_type
  sn_public_1_id     = module.vpc.sn_public_1_id
  sn_public_2_id     = module.vpc.sn_public_2_id
}