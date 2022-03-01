output "vpc" {
    description = "Main VPC resource"
    value       = aws_vpc.vpc
}

output "igw" {
    description = "Internet gateway resource"
    value       = aws_internet_gateway.igw
}

output "private_subnets" {
    description = "Private subnets in VPC"
    value       = aws_subnet.private
}

output "public_subnets" {
    description = "Public subnets in VPC"
    value       = aws_subnet.public
}

