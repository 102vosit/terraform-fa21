resource "aws_instance" "dev" {
  ami           = "ami-0c02fb55956c7d316"
  subnet_id     = var.subnet_id
  instance_type = "t2.micro"
  tags = {
    "Name" = "web-server"
  }
}

variable "subnet_id" {
  type    = string
  default = ""
}
