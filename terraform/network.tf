#-----------------------------------------------------------------
# VPC
#-----------------------------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name    = "${var.project}-${var.environment}-vpc"
    Project = var.project
    Env     = var.environment
  }
}

#-----------------------------------------------------------------
# Public Subnet
#-----------------------------------------------------------------

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1c"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project}-${var.environment}-public-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}



#-----------------------------------------------------------------
# application
#-----------------------------------------------------------------

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1a"
  cidr_block              = "10.0.8.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1a"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "us-east-1c"
  cidr_block              = "10.0.9.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.project}-${var.environment}-private-subnet-1c"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}


#-----------------------------------------------------------------
# RouteTable
#-----------------------------------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-pubulic-rt"
    Project = var.project
    Env     = var.environment
    Type    = "public"
  }
}

resource "aws_route_table_association" "public_rt_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_rt_1c" {
  subnet_id      = aws_subnet.public_subnet_1c.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-private-rt"
    Project = var.project
    Env     = var.environment
    Type    = "private"
  }
}

resource "aws_route_table_association" "private_rt_1a" {
  subnet_id      = aws_subnet.private_subnet_1a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_rt_1c" {
  subnet_id      = aws_subnet.private_subnet_1c.id
  route_table_id = aws_route_table.private_rt.id
}

#-----------------------------------------------------------------
# Internet Gateway
#-----------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-${var.environment}-igw"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "public_rt_igw_r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#-----------------------------------------------------------------
# NAT Gateway
#-----------------------------------------------------------------

resource "aws_eip" "nat_eip_A" {
  vpc = true
}


resource "aws_nat_gateway" "ngwA" {
  allocation_id = aws_eip.nat_eip_A.id
  subnet_id     = aws_subnet.public_subnet_1a.id

  tags = {
    Name    = "${var.project}-${var.environment}-ngw-A"
    Project = var.project
    Env     = var.environment
  }
}

resource "aws_route" "private_rt_nat_a_r" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ngwA.id
}

#-----------------------------------------------------------------
# S3 VPCEndopoint
#-----------------------------------------------------------------

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  tags = {
    "Name" = "${var.project}-${var.environment}-s3-ep"
  }
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = aws_route_table.private_rt.id
}