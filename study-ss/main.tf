provider "aws" {
  region = "us-east-1"
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.cidr_blocks.1
  tags = {
    Name = "Public-Subnet-${var.tags}" # Public-Subnet-DEV
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = var.cidr_blocks.2
  tags = {
    Name = "Private-Subnet-${var.tags}" # Private-Subnet-DEV
  }
}

resource "aws_vpc" "dev_vpc" {
  cidr_block = var.cidr_blocks.0
  tags = {
    Name = "VPC-${var.tags}" # VPC-DEV
  }
}

variable "cidr_blocks" {
  type = list(any)
}

variable "tags" {
  type = string
}
