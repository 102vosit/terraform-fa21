output "vpc_info" {
  description = "This output is for VPC"
  value = [
    aws_vpc.main.id,
    aws_vpc.main.cidr_block,
    aws_vpc.main.arn
  ]
}

output "public_subnet_info" {
  description = "This output is for subnet"
  value = [
    aws_subnet.public_subnet_one.id,
    aws_subnet.public_subnet_one.cidr_block,
    aws_subnet.public_subnet_one.arn
  ]
}
