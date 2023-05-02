data "aws_secretsmanager_secret_version" "secret" {
  secret_id = var.sm_secret_id
}
resource "aws_db_instance" "this" {
  identifier             = var.rds_identifier
  engine            = var.rds_engine
  engine_version    = var.rds_engine_version
  instance_class    = var.rds_instance_class
  storage_type           = var.rds_storage_type  
  allocated_storage = var.rds_allocated_storage  
  db_name           = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_name"]
  username             = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["username"]
  password             = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["password"]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [var.vpc_security_group_ids]
  parameter_group_name = var.rds_parameter_group_name
  skip_final_snapshot  = var.rds_skip_final_snapshot
  publicly_accessible  = var.rds_publicly_accessible
}

resource "aws_db_subnet_group" "db_subnet" {
  name       = var.db_subnet_group_name
  subnet_ids = [var.pri_sub_ids[0], var.pri_sub_ids[1]]
  tags       = var.db_subnet_tags
}
