# Tag for VPC and Subnet
variable "tag" {
  type        = string
  description = "This tag is applied for VPC and SUBNETS"
  default     = "TEST"
}

variable "vpc_cidr" {
  type        = string
  description = "This cidr for VPC"
  default     = "20.10.0.0/16"
}

variable "subnet_cidr" {
  type        = list(any)
  description = "This cidr for Subnets"
  default = [
    "20.10.1.0/24", "20.10.2.0/24", "20.10.3.0/24", "20.10.4.0/24", # public subnets
    "20.10.5.0/24", "20.10.6.0/24", "20.10.7.0/24", "20.10.8.0/24"  # private subnets
  ]
}
