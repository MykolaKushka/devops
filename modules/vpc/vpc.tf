resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-igw"
  })
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-public-${count.index + 1}"
    Tier = "public"
  })
}

# Private subnets
resource "aws_subnet" "private" {
  count                   = length(var.private_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-private-${count.index + 1}"
    Tier = "private"
  })
}

# NAT EIP
resource "aws_eip" "nat" {
  vpc = true

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat-eip"
  })
}

# NAT Gateway (in the first public subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(var.tags, {
    Name = "${var.vpc_name}-nat"
  })

  depends_on = [aws_internet_gateway.igw]
}
