variable "vpc_cidr" {
  type    = string
}
variable "pub_subnet_cidr" {
  type    = string
}
variable "prv_subnet_cidr" {
  type    = string
}
variable "av_zones" {
  type = list
}
variable "tag" {
  type = string
}
