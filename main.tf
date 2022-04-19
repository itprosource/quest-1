terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  cloud {
    organization = "athome"
    workspaces {
      name = "quest-1"
    }
  }
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr

  tags = {
    Name = var.name
  }
}

# Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  cidr_block = element(var.public_subnets,count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs,count.index)

  tags = {
    Name = "${var.name}-public-${count.index+1}"
  }
}

# Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  cidr_block = element(var.private_subnets,count.index)
  vpc_id = aws_vpc.vpc.id
  availability_zone = element(var.azs,count.index)

  tags = {
    Name = "${var.name}-private-${count.index+1}"
  }
}

# Public Route Table
resource "aws_route_table" "rte-public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-public"
  }
}

resource "aws_route" "igw_rt" {
  route_table_id         = aws_route_table.rte-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.int_gateway.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public_rte" {
  count = length(var.public_subnets)
  subnet_id = element(aws_subnet.public.*.id,count.index)
  route_table_id = aws_route_table.rte-public.id
}

# Private Route Table
resource "aws_route_table" "rte-private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.name}-private-rt"
  }
}

resource "aws_route_table_association" "private_rte" {
  count = length(var.private_subnets)
  subnet_id = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.rte-private.id
}

# IGW test
resource "aws_internet_gateway" "int_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}

resource "aws_alb" "application_load_balancer" {
  name               = "${var.name}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public.*.id
  security_groups    = [aws_security_group.load_balancer_security_group.id]

  tags = {
    Name        = "${var.name}-alb"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.id
  }
}

resource "aws_security_group" "load_balancer_security_group" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.name}-sg"
  }
}

resource "aws_lb_target_group" "target_group" {
  name        = "${var.name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name        = "${var.name}-lb-tg"
  }
}






