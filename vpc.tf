# VPC
resource "aws_vpc" "deepfence-lab-vpc" {
  cidr_block            = "10.101.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  
  tags = {
    Name = "deepfence-lab"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "deepfence-lab-gw" {
  vpc_id = aws_vpc.deepfence-lab-vpc.id

  tags = {
    Name = "deepfence-lab"
  }
}

# Lab Subnet
resource "aws_subnet" "deepfence-lab-subnet-public" {
  vpc_id                    = aws_vpc.deepfence-lab-vpc.id
  cidr_block                = "10.101.1.0/24"
  availability_zone         = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "deepfence-lab"
  }
}

# Route Tables
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.deepfence-lab-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.deepfence-lab-gw.id
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public-subnet-assoc" {
  route_table_id = aws_route_table.public-route.id
  subnet_id      = aws_subnet.deepfence-lab-subnet-public.id
  depends_on     = [aws_route_table.public-route, aws_subnet.deepfence-lab-subnet-public]
}

#VPC Security Group
resource "aws_security_group" "deepfence-lab-sg" {
  name   = "deepfence-lab-security-group"
  vpc_id = aws_vpc.deepfence-lab-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 0
    to_port     = 65535
    self        = true
  }
  
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0 
    to_port     = 0 
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "deepfence-lab"
  }
}