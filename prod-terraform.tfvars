#AWS PROVIDER AND NAMESPACE TFVARS
region    = "us-east-2"
profile   = "default"
namespace = "Prod"
#VPC TFVARS
vpc_cidr_block = "10.0.0.0/16"
vpc_tags = {
  Name    = "VPC"
  Worker  = "employ678@gmail.com"
  Purpose = "Terraform Testing in Work Environment DEV"
  Enddate = "99-09-9999"
}
vpc_public_subnets_cidr  = ["10.0.1.0/24", "10.0.2.0/24"]
vpc_public_subnets_az    = ["us-east-2a", "us-east-2b"]
vpc_private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
vpc_private_subnets_az   = ["us-east-2a", "us-east-2b"]
pub_sub_tag = {
  Type = "Internet Facing"
}
pri_sub_tag = {
  Type = "Internal"
}
pub_map_public_ip_on_launch = true
pri_map_public_ip_on_launch = false
igw_description = {
  Name = "IGW"
}
eip_description = {
  Name = "EIP"
}
nat_description = {
  Name = "NAT"
}
route_table_cidr = "0.0.0.0/0"
#SECURITY GROUP TFVARS
aws_sg_name            = "sg"
aws_sg_description     = "test sg"
sg_ports               = [22, 80, 8080, 3306]
sg_ingress_description = "SSH from VPC"
#SECRET MANAGER TFVARS
sm_secret_id = "serialkiller"
#RDS TFVARS
rds_identifier           = "rds-db-instance"
rds_engine               = "mariadb"
rds_engine_version       = "10.3"
rds_instance_class       = "db.t2.micro"
rds_allocated_storage    = 20
rds_storage_type         = "gp2"
rds_parameter_group_name = "default.mariadb10.3"
rds_skip_final_snapshot  = true
rds_publicly_accessible  = false
#DB_SUBNET_GROUP TFVARS
db_subnet_group_name = "rds-db-subnet-group"
db_subnet_tags = {
  Name = "RDS-DB-subnet-group"
}
#INSTANCE-AUTOSCALING TFVARS
key_name   = "yek"
image_type = "t2.micro"
template_tags = {
  bastion_host_template     = "bastion_host_server"
  nginx_webserver_template  = "nginx_webserver_server"
  tomcat_webserver_template = "tomcat_webserver_server"
  rds_db_template           = "rds_db_server"
}
#ALB TFVARS
nginx_alb_tags = {
  Name = "ALB_NGINX"
}
tomcat_alb_tags = {
  Name = "ALB_TOMCAT"
}
