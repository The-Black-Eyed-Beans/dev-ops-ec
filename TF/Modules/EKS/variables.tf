variable "app_name" {
  type        = string
  description = "Name of application (used to label components)"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet cidrs"
}