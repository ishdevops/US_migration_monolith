resource "aws_vpc" "vpc_dev" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc_dev"
  }
}

# adding public subnet Zone A
resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public_subnet__a"
  }
}

 # adding public subnet Zone B
 resource "aws_subnet" "public_subnet_b" {
   vpc_id                  = aws_vpc.vpc_dev.id
   cidr_block              = "10.0.20.0/24"
   map_public_ip_on_launch = true
   availability_zone       = "us-east-1b"

   tags = {
     Name = "public_subnet_b"
   }
 }

# adding private subnet Zone A
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.30.0/24"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "private_subnet_a"
  }
}

# adding private subnet Zone B
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.40.0/24"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "private_subnet_b"
  }
}

# creating public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name      = "public_route_table"
  }
}

# Associate the Public Route Table with the Public Subnet A
resource "aws_route_table_association" "public_route_association_a" {
  subnet_id = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate the Public Route Table with the Public Subnet B
resource "aws_route_table_association" "public_route_association_b" {
  subnet_id = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public_route_table.id
}

# creating private route table
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc_dev.id
    
    tags = {
        Name = "private_route_table"
    }
}

# Associate the Private Route Table with the Private Subnet A
resource "aws_route_table_association" "private_route_association_a" {
  subnet_id = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate the Private Route Table with the Private Subnet B
resource "aws_route_table_association" "private_route_association_b" {
  subnet_id = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table.id
}

# adding internet gateway for external communication
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name      = "internet_gateway"
  }
}

 # create external route to IGW
 resource "aws_route" "public_route" {
   route_table_id         = aws_route_table.public_route_table.id 
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.internet_gateway.id
 }

# adding an elastic ip for Nat
resource "aws_eip" "elastic_ip" {
  vpc = true
}

#creating the nat gateway
 resource "aws_nat_gateway" "nat_gw" {
   allocation_id = aws_eip.elastic_ip.id 
   subnet_id     = aws_subnet.public_subnet_a.id
   tags = {
    Name = "nat_gw"
   }
 }

#route for Nat-Gateway
resource "aws_route" "nat_route" {
    route_table_id         = aws_route_table.private_route_table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_nat_gateway.nat_gw.id
    depends_on = [
      aws_route_table.private_route_table,
    ]
}

