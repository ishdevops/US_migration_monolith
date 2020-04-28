resource "aws_vpc" "vpc_dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "US Dev VPC"
  }
}

# adding public subnet Zone A
resource "aws_subnet" "public_subnet_mgt_a" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.1.30.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Public Subnet managment a"
  }
}

# # adding public subnet Zone B
# resource "aws_subnet" "public_subnet_b" {
#   vpc_id                  = aws_vpc.vpc_dev.id
#   cidr_block              = "10.1.31.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1b"

#   tags = {
#     Name = "Public Subnet B"
#   }
# }

# # adding public subnet Zone C
# resource "aws_subnet" "public_subnet_c" {
#   vpc_id                  = aws_vpc.vpc_dev.id
#   cidr_block              = "10.1.32.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1c"

#   tags = {
#     Name = "Public Subnet C"
#   }
# }

# adding private subnet Zone A
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.1.101.0/24"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Private Subnet A"
  }
}

# adding private subnet Zone B
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.1.102.0/24"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Private Subnet Management B"
  }
}

# adding private subnet Zone C
resource "aws_subnet" "private_subnet_c" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.1.103.0/24"
  availability_zone       = "us-east-1c"

  tags = {
    Name = "Private Subnet Management C"
  }
}

# adding internet gateway for external communication
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name      = "Internet Gateway"
  }
}

# creating public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_dev.id

   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name      = "Public Subnet Route Table"
  }
}

# # create external route to IGW
# resource "aws_route" "external_route" {
#   route_table_id         = aws_vpc.vpc_dev.public_route_table.id 
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.internet_gateway.id
# }

# # adding an elastic ip
# resource "aws_eip" "elastic_ip" {
#   vpc        = true
#   depends_on = [aws_internet_gateway.internet_gateway]
# }

# #creating the nat gateway
# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.elastic_ip.id 
#   subnet_id     = aws_subnet.public_subnet_mgt_a.id
#   depends_on    = [aws_internet_gateway.internet_gateway]
# }

# #adding private route table to nat
# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat.id
# }

# #adding public route table to igw
# resource "aws_route" "public_route" {
#   route_table_id         = aws_route_table.public_route_table.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.internet_gateway.id
# }