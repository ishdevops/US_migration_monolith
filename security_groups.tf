resource "aws_security_group" "allow443" {
  name        = "mono_https_public"
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
    Name = "mono_https_public"
  }
}

resource "aws_security_group" "allow80" {
  name        = "mono_http_public"
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
    Name = "mono_http_public"
  }
}

resource "aws_security_group" "SQLServerSG" {
  name        = "mono_sql_server"
  description = "Allow SQL Server"
  vpc_id      = aws_vpc.vpc_dev.id 

  ingress {
    description = "HTTP from VPC"
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
    Name = "mono_sql_server"
  }
}

resource "aws_security_group" "WindowsRDP" {
  name        = "mono_rdp"
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
    Name = "mono_rdp"
  }
}



