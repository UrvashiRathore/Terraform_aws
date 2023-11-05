resource "aws_vpc" "s7" {
  cidr_block = "10.0.0.0/16"

tags = {
    Names = "Major_Proj"
}
}
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.s7.id
  cidr_block = "10.0.7.0/24"
  tags = {
    Name = "Public subnet "
  }
}
 


resource "aws_security_group" "MJ-SG" {
  name        = "Major Project - SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.s7.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }

  tags = {
    Name = "Major_Proj-securitygroup"
  }
}

resource "aws_internet_gateway" "MJ-gw" {
  vpc_id = aws_vpc.s7.id

  tags = {
    Name = "major_proj_ig"
  }
}

resource "aws_route_table" "MJ-RT" {
  vpc_id = aws_vpc.s7.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MJ-gw.id
  }

  tags = {
    Name = "major_proj_rt"
  }
}
resource "aws_route_table_association" "MJ-AS" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.MJ-RT.id
}

resource "aws_instance" "MJ-EC2" {
  ami           = "ami-02e94b011299ef128"
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.MJ-SG.id]

  connection {
    type = "ssh"
    host = self.public-ip 
    user = ec2-user
    
  }
  tags = {
    Name = "Web Server"
  }
}

resource "aws_eip" "MJ-EIP" {
  instance = aws_instance.MJ-EC2.id
  domain   = "vpc" 
}

