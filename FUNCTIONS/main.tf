/*
locals {
  regions  = ["us-east-1", "us-east-2", "us-west-1", "us-west-2"]
  av_zones = ["us-east-1a", "us-east-2a", "us-west-1a", "us-west-2a"]
  cidrs    = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24"]
}

output "regions" {
  value = local.regions
}
output "av_zones" {
  value = local.av_zones
}

output "cidrs" {
  value = local.cidrs
}

locals {
  user = ["admin", "developer", "devops"]
}

variable "user_names" {
  type    = list(any)
  default = ["David", "Tom", "Roman", "Admin", "dev", "Opsteam", "Contractor"]
}

resource "aws_iam_user" "name1" {
  count = length(var.user_names)
  name  = element(var.user_names, count.index)
}

output "list_length" {
  value = length(var.user_names)
}
*/

resource "aws_default_vpc" "name" {
  tags = {
    Name = "default-vpc"
  }
}

locals {
  map = {
      "HTTPS" = {
          port = 443,
          protocol = "tcp"
          cidr_blocks = ["10.1.0.0/16"]
      }
      "HTTP" ={
          port = 80,
          protocol = "udp"
          cidr_blocks = ["20.0.1.0/24"]
      }
      "SSH" = {
          port = 22,
          protocol = "tcp"
          cidr_blocks = ["10.0.1.0/24"]
      }
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.name.id

  dynamic "ingress" {
    for_each = local.map
    content {
      description = ingress.key
      from_port   = ingress.value.port
      to_port     = ingress.value.port 
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


