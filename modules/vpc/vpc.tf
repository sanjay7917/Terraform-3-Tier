#CREATE VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr_block
  tags = merge(var.vpc_tags, { Name = "${var.namespace}-VPC"})
}
#CREATE PUBLIC SUBNET
resource "aws_subnet" "pub_sub" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = length(var.vpc_public_subnets_cidr)
  cidr_block              = element(var.vpc_public_subnets_cidr, count.index)
  availability_zone       = element(var.vpc_public_subnets_az, count.index)
  map_public_ip_on_launch = var.pub_map_public_ip_on_launch
  tags                    = merge(var.pub_sub_tag, { Name = "${var.namespace}-PublicSubnet-${count.index + 1}" })
}
resource "aws_subnet" "pri_sub" {
  vpc_id                  = aws_vpc.myvpc.id
  count                   = length(var.vpc_private_subnets_cidr)
  cidr_block              = element(var.vpc_private_subnets_cidr, count.index)
  availability_zone       = element(var.vpc_private_subnets_az, count.index)
  map_public_ip_on_launch = var.pri_map_public_ip_on_launch
  tags                    = merge(var.pri_sub_tag, { Name = "${var.namespace}-PrivateSubnet-${count.index + 1}" })
}

#CREATE IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags   = merge(var.vpc_tags , { Name = "${var.namespace}-VPC-IGW"})
}

#CREATE PUBLIC ROUTE TABLE
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
}

#ASSOCIATE PUBLIC SUBNET TO PUBLIC ROUTE TABLE
resource "aws_route_table_association" "pub_rts" {
  count          = length(var.vpc_public_subnets_cidr)
  subnet_id      = aws_subnet.pub_sub[count.index].id
  route_table_id = aws_route_table.pub_rt.id
}

#CREATE ELASTIC IP
resource "aws_eip" "eip" {
  vpc      = true
  tags     = merge(var.nat_description, { Name = "${var.namespace}-VPC-EIP"})
}

#CREATE NAT GATEWAY
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.pub_sub[0].id
  tags = merge(var.nat_description, { Name = "${var.namespace}-VPC-NAT"})
}

#CREATE PRIVATE ROUTE TABLE
resource "aws_route_table" "pri_rt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = var.route_table_cidr
    gateway_id = aws_nat_gateway.nat.id
  }
}

#ASSOCIATE PRIVATE SUBNET TO PUBLIC ROUTE TABLE
resource "aws_route_table_association" "pri_rts" {
  count          = length(var.vpc_private_subnets_cidr)
  subnet_id      = aws_subnet.pri_sub[count.index].id
  route_table_id = aws_route_table.pri_rt.id
}

#SECURITY GROUP VARIABLE
resource "aws_security_group" "sg" {
  name        = var.aws_sg_name
  description = var.aws_sg_description
  vpc_id      = aws_vpc.myvpc.id
  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      description = var.sg_ingress_description
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}