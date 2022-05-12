resource "aws_instance" "dev" {
  ami           = var.ami_id
  #subnet_id     = var.subnet_id
  instance_type = var.instance_type
  tags = {
    "Name" = "web-server"
  }
}
variable "ami_id" {
  type = string
}
variable "instance_type" {
  type = string
}
