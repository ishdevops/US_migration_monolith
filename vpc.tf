data "aws_acm_certificate" "salary_finance" {
  domain = "salaryfinance.club"
}

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
  cidr_block              = "10.0.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Public Subnet managment a"
  }
}

 # adding public subnet Zone B
 resource "aws_subnet" "public_subnet_b" {
   vpc_id                  = aws_vpc.vpc_dev.id
   cidr_block              = "10.0.20.0/24"
   map_public_ip_on_launch = true
   availability_zone       = "us-east-1b"

   tags = {
     Name = "Public Subnet B"
   }
 }

# # adding public subnet Zone C
#  resource "aws_subnet" "public_subnet_c" {
#    vpc_id                  = aws_vpc.vpc_dev.id
#    cidr_block              = "10.1.32.0/24"
#    map_public_ip_on_launch = true
#    availability_zone       = "us-east-1c"

#    tags = {
#      name = "public subnet c"
#    }
# }

# adding private subnet Zone A
resource "aws_subnet" "private_subnet_a" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.30.0/24"
  availability_zone       = "us-east-1a"

  tags = {
    Name = "Private Subnet A"
  }
}

# adding private subnet Zone B
resource "aws_subnet" "private_subnet_b" {
  vpc_id                  = aws_vpc.vpc_dev.id
  cidr_block              = "10.0.40.0/24"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "Private Subnet Management B"
  }
}

# adding private subnet Zone C
 resource "aws_subnet" "private_subnet_c" {
   vpc_id                  = aws_vpc.vpc_dev.id
   cidr_block              = "10.0.50.0/24"
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
resource "aws_route_table" "vpc_dev_route_table" {
  vpc_id = aws_vpc.vpc_dev.id

  tags = {
    Name      = "Public Subnet Route Table"
  }
}

 # create external route to IGW
 resource "aws_route" "vpc_dev_route" {
   route_table_id         = aws_route_table.vpc_dev_route_table.id 
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.internet_gateway.id
 }

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "dev_vpc_association" {
  gateway_id = aws_internet_gateway.internet_gateway.id
  route_table_id = aws_route_table.vpc_dev_route_table.id
}

# adding an elastic ip
resource "aws_eip" "elastic_ip" {
  vpc = true
  depends_on = [aws_internet_gateway.internet_gateway]
 }

#creating the nat gateway
 resource "aws_nat_gateway" "nat" {
   allocation_id = aws_eip.elastic_ip.id 
  # vpc_id = aws_vpc.vpc_dev.id
   subnet_id     = aws_subnet.public_subnet_b.id
   depends_on    = [aws_internet_gateway.internet_gateway]
 }


resource "aws_subnet" "nat-subnet" {
    vpc_id = aws_vpc.vpc_dev.id
    cidr_block = "10.0.60.0/24"
    
    tags = {
        Name = "nat-subnet"
    }
}
resource "aws_route_table" "nat-routetable" {
    vpc_id = aws_vpc.vpc_dev.id
    
    tags = {
        Name = "nat-routetable"
    }
}

// resource "aws_route" "nat-route" {
    route_table_id = aws_route_table.nat-routetable.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
    depends_on = [
        aws_route_table.nat-routetable
    ]
}

# #adding private route table to nat
#  resource "aws_route" "vpc_dev_private_route" {
#    route_table_id         = aws_route_table.vpc_dev_private_route_table.id
#    destination_cidr_block = "0.0.0.0/0"
#    nat_gateway_id         = aws_nat_gateway.nat.id
#  }

