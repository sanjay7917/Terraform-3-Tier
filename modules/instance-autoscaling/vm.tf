resource "aws_key_pair" "key" {
  key_name   = var.key_name
  public_key = file("${path.module}/id_rsa.pub")
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
#BASTION HOST CONFIGURATION
resource "aws_launch_template" "bastion_host_template" {
  name                   = "bastion_host_template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.image_type
  vpc_security_group_ids = [var.vpc_security_group_ids]
  key_name               = aws_key_pair.key.key_name
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo '${filebase64("${path.module}/id_rsa")}' | base64 --decode > /home/ubuntu/id_rsa
    sudo chmod 600 /home/ubuntu/id_rsa
  EOF
  )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${lookup(var.template_tags, "bastion_host_template")}"
    }
  }
}
resource "aws_autoscaling_group" "bastion_host_scaling" {
  name                      = "bastion_host_scaling"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  vpc_zone_identifier       = var.pub_sub_ids
  launch_template {
    id      = aws_launch_template.bastion_host_template.id
    version = "$Latest"
  }
}
#NGINX WEBSERVER CONFIGURATION
resource "aws_launch_template" "nginx_webserver_template" {
  name            = "nginx_webserver_template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.image_type
  vpc_security_group_ids = [var.vpc_security_group_ids]
  key_name               = aws_key_pair.key.key_name
  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt-get install nginx -y
    sudo systemctl start nginx 
    sudo systemctl enable nginx
    sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/index.html -P /var/www/html/ 
    sudo sed -i '23i\
          server_names_hash_bucket_size 128;' /etc/nginx/nginx.conf
    sudo sed -i '38i\
          server {\
              listen 80;\
              listen [::]:80;\
              server_name ${var.nginx_lb_dns};\
              location / {\
                  proxy_pass http://${var.tomcat_lb_dns}/student/;\
              }\
          }' /etc/nginx/nginx.conf
    sudo systemctl restart nginx
  EOF
  #BELOW SCRIPT IS USED IN INDEX.HTML TO REDIRECT TO INTERNAL LOAD BALANCER USE THIS INSTEAD OF REVERSE PROXY
    # sudo sed -i 's|<h2 style="text-align: center;"><a href="student"><strong>Enter to Student Application</strong></a></h2>|<h2 style="text-align: center;"><a href="http://${var.tomcat_lb_dns}/student/"><strong>Enter to Student Application</strong></a></h2>|g' /var/www/html/index.html
    )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${lookup(var.template_tags, "nginx_webserver_template")}"
    }
  }
}
resource "aws_autoscaling_group" "nginx_webserver_scaling" {
  name                      = "nginx_webserver_scaling"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  # vpc_zone_identifier       = var.pri_sub_ids
  vpc_zone_identifier = [var.pri_sub_ids[0], var.pri_sub_ids[1]] #IF desired_capacity = 2
  launch_template {
    id      = aws_launch_template.nginx_webserver_template.id
    version = "$Latest"
  }
  # target_group_arns = var.nginx_lb_target_group
}
resource "aws_autoscaling_attachment" "nginx_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.nginx_webserver_scaling.name
  lb_target_group_arn    = var.nginx_lb_target_group
}
# TOMCAT WEBSERVER CONFIGURATION
resource "aws_launch_template" "tomcat_webserver_template" {
  name            = "tomcat_webserver_template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.image_type
  vpc_security_group_ids = [var.vpc_security_group_ids]
  key_name               = aws_key_pair.key.key_name
  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt-get install openjdk-11-jre -y
    sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.74/bin/apache-tomcat-9.0.74.tar.gz
    sudo tar -xzvf apache-tomcat-9.0.74.tar.gz -C /opt
    sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war -P /opt/apache-tomcat-9.0.74/webapps
    sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar -P /opt/apache-tomcat-9.0.74/lib
    sudo sed -i '26i\
    <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxTotal="500" maxIdle="30" maxWaitMillis="1000" username="${var.rds_username}" password="${var.rds_password}" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://${var.rds_endpoint}:3306/studentapp?useUnicode=yes&amp;characterEncoding=utf8"/>\
    ' /opt/apache-tomcat-9.0.74/conf/context.xml
    cd /opt/apache-tomcat-9.0.74/bin/
    sudo ./catalina.sh start

  EOF
    )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${lookup(var.template_tags, "tomcat_webserver_template")}"
    }
  }
}
resource "aws_autoscaling_group" "tomcat_webserver_scaling" {
  name                      = "tomcat_webserver_scaling"
  max_size                  = 2
  min_size                  = 2
  desired_capacity          = 2
  health_check_grace_period = 300
  vpc_zone_identifier = [var.pri_sub_ids[2], var.pri_sub_ids[3]] #IF desired_capacity = 2
  launch_template {
    id      = aws_launch_template.tomcat_webserver_template.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_attachment" "tomcat_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.tomcat_webserver_scaling.name
  lb_target_group_arn    = var.tomcat_lb_target_group
}
# RDS DB CONFIGURATION
resource "aws_launch_template" "rds_db_template" {
  name            = "rds_db_template"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = var.image_type
  vpc_security_group_ids = [var.vpc_security_group_ids]
  key_name               = aws_key_pair.key.key_name
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo '${filebase64("${path.module}/sqlscript.sql")}' | base64 --decode > /tmp/sqlscript.sql
    sudo apt update -y
    sudo apt-get install mysql* -y
    sudo systemctl start mysql
    sudo systemctl enable mysql
    mysql -h ${var.rds_endpoint} -u ${var.rds_username} -p${var.rds_password} < /tmp/sqlscript.sql
    rm /tmp/sqlscript.sql

  EOF
    )
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${lookup(var.template_tags, "rds_db_template")}"
    }
  }
}
resource "aws_autoscaling_group" "rds_dbserver_scaling" {
  name                      = "rds_dbserver_scaling"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  health_check_grace_period = 300
  vpc_zone_identifier       = var.pri_sub_ids
  launch_template {
    id      = aws_launch_template.rds_db_template.id
    version = "$Latest"
  }
}

