# Main VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "${var.app_name}-vpc"
  }
}

# Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.app_name}-igw"
  }
}

# Private subnets
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(var.private_subnets)
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "${var.app_name}-private-subnet-${count.index + 1}"
  }
}

# Public subnet(s)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets)
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.app_name}-public-subnet-${count.index + 1}"
  }
}

# IGW Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Public subnet associations to IGW route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# EIP for NAT gateways
resource "aws_eip" "eip" {
  vpc = true
  count = length(var.public_subnets)
}

# NAT gateways
resource "aws_nat_gateway" "ng" {
  count = length(var.public_subnets)
  allocation_id = element(aws_eip.eip.*.id, count.index)
  subnet_id = element(aws_subnet.public.*.id, count.index)

  tags = {
    "Name" = "${var.app_name}-ng-${count.index + 1}"
  }
}

# NGW route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  count = length(var.public_subnets)

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.ng.*.id, count.index)
  }
}

# Private subnet associations to NGW route table
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets)
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# Application Load Balancer Security Group
resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.app_name}-sg"
  }
}

# Create ingress rules for ALB SG
resource "aws_security_group_rule" "load_balancer_ingress" {
  count             = length(var.alb_ingress_rules)
  type              = "ingress"
  from_port         = var.alb_ingress_rules[count.index].from
  to_port           = var.alb_ingress_rules[count.index].to
  protocol          = var.alb_ingress_rules[count.index].protocol
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.load_balancer_security_group.id
}

# Create ingress rules for ALB SG
resource "aws_security_group_rule" "load_balancer_egress" {
  count             = length(var.alb_egress_rules)
  type              = "egress"
  from_port         = var.alb_egress_rules[count.index].from
  to_port           = var.alb_egress_rules[count.index].to
  protocol          = var.alb_egress_rules[count.index].protocol
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.load_balancer_security_group.id
}

# Load Balancer
resource "aws_alb" "application_load_balancer" {
  name               = "${var.app_name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.app_name}-alb"
  }
}