variable "vpc_cidr" {
  type = string
}
variable "pub_subnet_cidr" {
  type = string
}
variable "prv_subnet_cidr" {
  type = string
}
variable "av_zones" {
  type = list(any)
}
variable "tag" {
  type = string
}

output "subnet_pub_id" {
  value = aws_subnet.public_subnet.id
}
