#SECRET MANAGER VARIABLE
variable "sm_secret_id" {
  type = string
}
#RDS VARIABLES
variable "rds_identifier" {
  type = string
}
variable "rds_engine" {
  type = string
}
variable "rds_engine_version" {
  type = string
}
variable "rds_instance_class" {
  type = string
}
variable "rds_allocated_storage" {
  type = number
}
variable "rds_storage_type" {
    type = string
}
variable "rds_parameter_group_name" {
  type = string
}
variable "rds_skip_final_snapshot" {
  type = bool
}
variable "rds_publicly_accessible" {
  type = bool
}
#DB_SUBNET_GROUP
variable "db_subnet_group_name" {
    type = string
}
variable "vpc_security_group_ids" {
    type = string
}
variable "pri_sub_ids" {
  type = list(string)
}
variable "db_subnet_tags" {
  type = map(any)
}
