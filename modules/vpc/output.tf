output "vpc_id" {
  value = aws_vpc.myvpc.id
}
output "vpc_security_group_ids" {
  value = aws_security_group.sg.id
}
output "pub_sub_ids" {
  value = aws_subnet.pub_sub[*].id
}
output "pri_sub_ids" {
  value = aws_subnet.pri_sub[*].id
}
output "pub_cidr_blocks" {
  value = var.vpc_public_subnets_cidr
}
output "pri_cidr_blocks" {
  value = var.vpc_private_subnets_cidr
}

