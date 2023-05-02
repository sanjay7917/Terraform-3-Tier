#!/bin/bash
#SSH KEY PERSMISSION
# sudo chmod 600 /home/ubuntu/id_rsa
#NGINX INSTALLATION
# sudo apt-get install nginx -y
# sudo systemctl start nginx 
# sudo systemctl enable nginx
# sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/index.html -P /var/www/html/
# sudo sed -i '23i\
#       server_names_hash_bucket_size 128;' /etc/nginx/nginx.conf
# sudo sed -i '38i\
#       server {\
#           listen 80;\
#           listen [::]:80;\
#           server_name ${var.nginx_lb_dns};\
#           location / {\
#               proxy_pass http://${var.internal_lb_dns}/student/;\
#           }\
#       }' /etc/nginx/nginx.conf
# <h2 style="text-align: center;"><a href="http://${var.internal_lb_dns}/student/"><strong>Enter to Student Application</strong></a></h2>
# sudo systemctl restart nginx
#TOMCAT INSTALLATION
# sudo apt update -y
# sudo apt-get install openjdk-11-jre -y
# sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.74/bin/apache-tomcat-9.0.74.tar.gz
# sudo tar -xzvf apache-tomcat-9.0.74.tar.gz -C /opt
# sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/student.war -P /opt/apache-tomcat-9.0.74/webapps
# sudo wget https://s3-us-west-2.amazonaws.com/studentapi-cit/mysql-connector.jar -P /opt/apache-tomcat-9.0.74/lib
# sudo sed -i '21i\
# <Resource name="jdbc/TestDB" auth="Container" type="javax.sql.DataSource" maxTotal="500" maxIdle="30" maxWaitMillis="1000" username="admin" password="Admin$123" driverClassName="com.mysql.jdbc.Driver" url="jdbc:mysql://${var.rds_endpoint}:3306/studentapp?useUnicode=yes&amp;characterEncoding=utf8"/>\
# ' apache-tomcat-9.0.74/conf/context.xml
# cd /opt/apache-tomcat-9.0.74/bin/
# sudo ./catalina.sh start

#RDS CONFIG
# sudo apt-get install mysql* -y
# sudo systemctl start mysql 
# sudo systemctl enable mysql
# sudo systemctl status mysql (DO NOT DO THIS)
# mysql -h terraform-20230427114740068200000001.cmomitk2ez52.us-east-2.rds.amazonaws.com -u admin -ppassword < sqlscript.sql
# CREATE DATABASE studentapp;
# show databases;
# use studentapp;
# CREATE TABLE if not exists students(student_id INT NOT NULL AUTO_INCREMENT,
# student_name VARCHAR(100) NOT NULL,
# student_addr VARCHAR(100) NOT NULL,
# student_age VARCHAR(3) NOT NULL,
# student_qual VARCHAR(20) NOT NULL,
# student_percent VARCHAR(10) NOT NULL,
# student_year_passed VARCHAR(10) NOT NULL,
# PRIMARY KEY (student_id)
# );
# aws secretsmanager get-secret-value  --secret-id hoja_bhai --region=us-east-2 | jq -r .SecretString | jq -r .password
# aws secretsmanager get-secret-value  --secret-id hoja_bhai --region=us-east-2 --query SecretString --output text (FOR SECRET MANAGER KEY AND VALUE IN JSON FORMAT)
# aws secretsmanager get-secret-value --secret-id hoja_bhai --query 'SecretString' --output text | jq -r 'to_entries[] | "\(.key)=\(.value)"' (FOR SECRET MANAGER KEY AND VALUE)
# aws secretsmanager get-secret-value --secret-id hoja_bhai --query 'SecretString' --output text | jq -r 'to_entries[] | "\(.value)"' (FOR SECRET MANAGER VALUE)
# "aws secretsmanager get-secret-value --secret-id hoja_bhai --query 'SecretString' --output text | jq -r 'to_entries[] | "\(.value)"' > $PA"
# echo terraform-20230429155332943100000001.cmomitk2ez52.us-east-2.rds.amazonaws.com:3306 | sed 's/:3306//g'
