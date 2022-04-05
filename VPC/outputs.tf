output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_cidr" {
  value = aws_subnet.public_subnet.cidr_block
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "greetings" {
  value = "Hello, Cloud engineers!!!"
}
