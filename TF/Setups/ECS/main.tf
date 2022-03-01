module "vpc" {
    source             = "../../Modules/VPC"
    app_name           = var.app_name
    vpc_cidr           = var.vpc_cidr
    private_subnets    = var.private_subnets
    public_subnets     = var.public_subnets
    availability_zones = var.availability_zones
    alb_ingress_rules  = var.alb_ingress_rules
    alb_egress_rules   = var.alb_egress_rules
}

module "ecs_cluster" {
    source   = "../../Modules/ECS"
    app_name = var.app_name
}