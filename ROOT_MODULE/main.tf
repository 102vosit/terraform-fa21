module "vpc" {
  source          = "../VPC"
  vpc_cidr        = "20.20.0.0/16"
  pub_subnet_cidr = "20.20.1.0/24"
  prv_subnet_cidr = "20.20.2.0/24"
  av_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  tag             = "Primary"
}

module "ec2" {
  source        = "git@github.com:102vosit/terraform-fa21.git//EC2"
  subnet_id     = module.vpc.subnet_pub_id
  ami_id        = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
}
