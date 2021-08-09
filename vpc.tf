resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = var.standard_tags
}

# Data source to get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Multiple subnets for multi-az
resource "aws_subnet" "main" {
  count = 3

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  vpc_id            = aws_vpc.main.id

  tags = merge({
    "kubernetes.io/cluster/k8s-deployment" = "shared"
    },
    var.standard_tags
  )
}
