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