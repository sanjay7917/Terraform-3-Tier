output "rds_endpoint" {
  value = split(":", aws_db_instance.this.endpoint)[0]
}
output "rds_db_name" {
  sensitive = true
  value = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["db_name"]
}
output "rds_username" {
  sensitive = true
  value = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["username"]
}
output "rds_password" {
  sensitive = true
  value = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["password"]
}