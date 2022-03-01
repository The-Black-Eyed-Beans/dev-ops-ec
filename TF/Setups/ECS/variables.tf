# AWS account variables
variable "aws-region" {
  type        = string
  description = "The AWS region you want to deploy to."
  sensitive   = true
}

variable "aws-access-key" {
  type        = string
  description = "The AWS access key for desired IAM user."
  sensitive   = true
}

variable "aws-secret-key" {
  type        = string
  description = "The AWS secret key for desired IAM user."
  sensitive   = true
}

# VPC vars
variable "app_name" {
  type        = string
  description = "Name of application (used to label components)"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for main vpc"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet cidrs"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet cidrs"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "alb_ingress_rules" {
    type = list(object({
        from     = number
        to       = number
        protocol = string
    }))
}

variable "alb_egress_rules" {
    type = list(object({
        from     = number
        to       = number
        protocol = string
    }))
}