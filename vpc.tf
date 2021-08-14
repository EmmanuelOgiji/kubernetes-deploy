resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = var.standard_tags
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge({
    Name = "rt-public"
    }, var.standard_tags
  )
}

# Data source to get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "private" {
  count                   = length(var.private_subnet_cidr_blocks)
  cidr_block              = var.private_subnet_cidr_blocks[count.index]
  vpc_id                  = aws_vpc.main.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = merge({
    "kubernetes.io/role/internal-elb" = 1
    },
    var.standard_tags
  )
}

# Multiple subnets for multi-az
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true


  tags = merge({
    "kubernetes.io/role/elb" = 1
    },
    var.standard_tags
  )
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}


# Grant the VPC internet access on its main route table
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Route table and subnet associations
resource "aws_route_table_association" "internet_access" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidr_blocks)
  vpc   = true
  tags  = var.standard_tags
}

resource "aws_nat_gateway" "nat-gw" {
  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = var.standard_tags
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw[count.index].id
  }

  tags = merge({
    Name = "rt-${count.index}"
    }, var.standard_tags
  )
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}