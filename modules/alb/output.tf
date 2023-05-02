output "nginx_lb_dns" {
  value = aws_lb.nginx_alb.dns_name
}
output "nginx_lb_target_group" {
  value = aws_lb_target_group.nginx_alb_tg.arn
}
output "tomcat_lb_dns" {
  value = aws_lb.tomcat_alb.dns_name
}
output "tomcat_lb_target_group" {
  value = aws_lb_target_group.tomcat_alb_tg.arn
}
