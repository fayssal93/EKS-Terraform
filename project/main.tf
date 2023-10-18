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
  source                   = "../modules/vpc"
  region                   = var.region
  vpc-gitlab               = var.vpc-gitlab
  vpc_cidr                 = var.vpc_cidr
  sn-gitlab-public-a_cidr  = var.sn-gitlab-public-a_cidr
  sn-gitlab-public-b_cidr  = var.sn-gitlab-public-b_cidr
  sn-gitlab-private-a_cidr = var.sn-gitlab-private-a_cidr
  sn-gitlab-private-b_cidr = var.sn-gitlab-private-b_cidr
}

module "nat_gateway" {
  source               = "../modules/nat_gateway"
  subnet_id            = module.vpc.sn-gitlab-public-a_cidr
  vpc_id               = module.vpc.vpc_id
  rt_gitlab_private_id = module.vpc.rt_gitlab_private_id
  rt_gitlab_public_id  = module.vpc.rt_gitlab_public_id
  internet_gateway_id  = module.vpc.internet_gateway_id

}
module "ec2_instance" {
  source = "../modules/ec2"

  instance_type      = var.instance_type
  ami_id             = var.ami_id
  subnet_id          = module.vpc.sn-gitlab-public-a_cidr
  key_name           = var.key_name
  security_group_ids = [module.nat_gateway.gitlab_security_group_id]
}