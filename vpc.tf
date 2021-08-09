resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = var.standard_tags
}

# Data source to get availability zones
data "aws_availability_zones" "all" {}

# Multiple subnets for multi-az
resource "aws_subnet" "main" {
  count             = length(var.subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.all.names[count.index]
  tags              = var.standard_tags
}
