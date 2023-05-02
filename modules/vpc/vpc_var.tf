#NAMESPACE VARIABLE
variable "namespace" {
  type = string
}
#VPC VARIABLE
variable "vpc_cidr_block" {
  type = string
}
variable "vpc_tags" {
  type = map(any)
}
variable "vpc_public_subnets_cidr" {
  type = list(any)
}
variable "vpc_public_subnets_az" {
  type = list(any)
}
variable "vpc_private_subnets_cidr" {
  type = list(any)
}
variable "vpc_private_subnets_az" {
  type = list(any)
}
variable "pub_sub_tag" {
  type = map(any)
}
variable "pri_sub_tag" {
  type = map(any)
}
variable "pub_map_public_ip_on_launch" {
  type = bool
}
variable "pri_map_public_ip_on_launch" {
  type = bool
}
variable "igw_description" {
  type = map(any)
}
variable "eip_description" {
  type = map(any)
}
variable "nat_description" {
  type = map(any)
}
variable "route_table_cidr" {
  type = string
}
#SECURITY GROUP VARIABLE
variable "aws_sg_name" {
  type = string
}
variable "aws_sg_description" {
  type = string
}
variable "sg_ports" {
  type = list(any)
}
variable "sg_ingress_description" {
  type = string
}