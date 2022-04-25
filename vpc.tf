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

resource "aws_route" "ngw_rt" {
  route_table_id = aws_route_table.rte-private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gateway.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private_rte" {
  count = length(var.private_subnets)
  subnet_id = element(aws_subnet.private.*.id,count.index)
  route_table_id = aws_route_table.rte-private.id
}

# IGW
resource "aws_internet_gateway" "int_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.name
  }
}

# NAT Gwy
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.public[0].id

  tags = {
    Name = var.name
  }

  depends_on = [aws_subnet.public]
}

resource "aws_eip" "nat" {
  vpc = true

  tags = {
    Name = var.name
  }
}