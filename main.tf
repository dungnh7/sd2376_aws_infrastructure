provider "aws" {
  region = var.region
}

module "networking" {
  source = "./modules/networking"
  region = var.region
  cluster_name = var.cluster_name
}

module "eks" {
  source       = "./modules/eks"
  vpc_id       = module.networking.vpc_id
  subnet_ids   = module.networking.subnet_ids
  cluster_name = var.cluster_name
}

module "ecr" {
  source = "./modules/ecr"
}

module "jenkins" {
  source            = "./modules/jenkins"
  subnet_id         = module.networking.public_subnet_ids[0]
  security_group_id = module.networking.security_group_id
}