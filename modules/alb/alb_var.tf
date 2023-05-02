variable "vpc_id" {
  type = string
}
variable "vpc_security_group_ids" {
  type = string
}
variable "pub_sub_ids" {
  type = list(string)
}
variable "pri_sub_ids" {
  type = list(string)
}
variable "nginx_alb_tags" {
  type = map(any)
}
variable "tomcat_alb_tags" {
  type = map(string)
}