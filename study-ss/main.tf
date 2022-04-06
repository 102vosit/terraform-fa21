# Creating main vpc
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    "Name" = "${var.tag}-VPC"
  }
}

# Creating subnets
resource "aws_subnet" "public_subnet_one" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.0
  tags = {
    "Name" = "${var.tag}-Public-Subnet-One"
  }
}

# Creating subnets
resource "aws_subnet" "public_subnet_two" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.1
  tags = {
    "Name" = "${var.tag}-Public-Subnet-Two"
  }
}

# Creating subnets
resource "aws_subnet" "public_subnet_three" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.2
  tags = {
    "Name" = "${var.tag}-Public-Subnet-Three"
  }
}

# Creating subnets
resource "aws_subnet" "public_subnet_four" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.3
  tags = {
    "Name" = "${var.tag}-Public-Subnet-Four"
  }
}

# Creating subnets
resource "aws_subnet" "private_subnet_one" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.4
  tags = {
    "Name" = "${var.tag}-Private-Subnet-One"
  }
}

# Creating subnets
resource "aws_subnet" "private_subnet_two" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.5
  tags = {
    "Name" = "${var.tag}-Private-Subnet-Two"
  }
}

# Creating subnets
resource "aws_subnet" "private_subnet_three" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.6
  tags = {
    "Name" = "${var.tag}-Private-Subnet-Three"
  }
}

# Creating subnets
resource "aws_subnet" "private_subnet_four" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet_cidr.7
  tags = {
    "Name" = "${var.tag}-Private-Subnet-Four"
  }
}
