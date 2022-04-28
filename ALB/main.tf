resource "aws_vpc" "temp_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    "Name" = "TEMP VPC"
  }
}

resource "aws_subnet" "public_subnet_one" {
  vpc_id            = aws_vpc.temp_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "Public Subnet One"
  }
}

resource "aws_subnet" "public_subnet_two" {
  vpc_id            = aws_vpc.temp_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    "Name" = "Public Subnet Two"
  }
}

resource "aws_internet_gateway" "internet_gw" {
  vpc_id = aws_vpc.temp_vpc.id
  tags = {
    "Name" = "Internet Gateway"
  }
}

resource "aws_route_table" "public_rt_one" {
  vpc_id = aws_vpc.temp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    "Name" = "Public Route Table One"
  }
}

resource "aws_route_table" "public_rt_two" { # added new route table
  vpc_id = aws_vpc.temp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gw.id
  }

  tags = {
    "Name" = "Public Route Table Two"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet_one.id
  route_table_id = aws_route_table.public_rt_one.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.public_subnet_two.id
  route_table_id = aws_route_table.public_rt_two.id
}

resource "aws_security_group" "allow-traffic" {
  name        = "allow-traffic"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.temp_vpc.id
  ingress {
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow Inbound Traffic"
  }
}

resource "aws_security_group" "backend-sg" {
  name        = "backend-security-group"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.temp_vpc.id
  ingress {
    description = "HTTP"
    security_groups = [ aws_security_group.allow-traffic.id ]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  ingress {
    description = "SSH"
    security_groups = [ aws_security_group.allow-traffic.id ]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow Inbound Backend"
  }
}

data "aws_ami" "amznlx2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*-gp2"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "ec2_launcher" {
  name_prefix                 = "alb-launcher"
  image_id                    = data.aws_ami.amznlx2.id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.backend-sg.id]
  user_data                   = file("user_data.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ec2_scaling_rule" {
  name                 = "ec2-scaling"
  vpc_zone_identifier  = [aws_subnet.public_subnet_one.id, aws_subnet.public_subnet_two.id]
  launch_configuration = aws_launch_configuration.ec2_launcher.name
  desired_capacity     = 2
  max_size             = 3
  min_size             = 1
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "ec2_alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow-traffic.id]
  subnets            = [aws_subnet.public_subnet_one.id, aws_subnet.public_subnet_two.id]
  tags = {
    "Name" = "ALB"
  }
}

resource "aws_lb_target_group" "ec2_target_group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.temp_vpc.id
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.ec2_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_target_group.arn
  }
}

resource "aws_autoscaling_attachment" "alb_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.ec2_scaling_rule.id
  alb_target_group_arn   = aws_lb_target_group.ec2_target_group.arn
}

output "alb_dns_name" {
  value = aws_lb.ec2_alb.dns_name
}
