resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow HTTPS inbound traffic"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_dev.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { 
    Name = "allow_https"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_dev.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

resource "aws_security_group" "sql_server_sg" {
  name        = "sql_server_sg"
  description = "Allow SQL Server"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "SQL Server access"
    from_port   = 1433
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_dev.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sql_server_sg"
  }
}

resource "aws_security_group" "windows_rpd" {
  name        = "windows_rdp"
  description = "Allow RDP"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "Allow RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_dev.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "windows_rdp"
  }
}

resource "aws_security_group" "jumpbox_sg" {
  name        = "jumpbox_sg"
  description = "Access for Jumpbox"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "Allow RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["18.130.69.215/32", "3.9.29.117/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jumpbox_sg"
  }
}

resource "aws_security_group" "monolaunch_instance_sg" {
  name        = "monolaunch_instance_sg"
  description = "Access to Monolaunch Instances"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "Allow All Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc_dev.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "monolaunch_instance_sg"
  }
}

resource "aws_security_group" "swarm_node_sg" {
  name        = "swarm_node_sg"
  description = "Security group for swarm node access"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "Allow All Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc_dev.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "swarm_node_sg"
  }
}

resource "aws_security_group" "swarm_internal_lb_sg" {
  name        = "swarm_internal_lb_sg"
  description = "Security group for swarm node access"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "Allow All Traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc_dev.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "swarm_internal_lb_sg"
  }
}
