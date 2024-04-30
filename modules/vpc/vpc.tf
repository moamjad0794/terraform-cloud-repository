resource "aws_vpc" "terraform-test-vpc" {
    cidr_block = var.vpc-cidr_block
    instance_tenancy = "default"
    enable_dns_hostnames = true
  tags = {
    Name="terraform-test-vpc"
  }
}

resource "aws_subnet" "public-subnet-1" {
    vpc_id = aws_vpc.terraform-test-vpc.id
    availability_zone = "us-east-1a"
    cidr_block = var.public-subnet-cidr
    map_public_ip_on_launch = true
    tags = {
      Name="public-subnet-1"
    }
}

resource "aws_subnet" "private-subnet-1" {
    vpc_id = aws_vpc.terraform-test-vpc.id
    availability_zone = "us-east-1a"
    cidr_block = var.private-subnet-cidr
    map_public_ip_on_launch = false
    tags = {
      Name="private-subnet-1"
    }
}

resource "aws_internet_gateway" "test-igw" {
    vpc_id = aws_vpc.terraform-test-vpc.id
    tags = {
      Name="test-igw"
    }
}

resource "aws_route_table" "public-rt-1" {
  vpc_id = aws_vpc.terraform-test-vpc.id
  tags = {
    Name="public-rt-1"
  }

}

resource "aws_route_table_association" "public-subnet-1-association" {
    route_table_id = aws_route_table.public-rt-1.id
    subnet_id = aws_subnet.public-subnet-1.id
}

resource "aws_route" "test-route" {
    route_table_id = aws_route_table.public-rt-1.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-igw.id
}

resource "aws_security_group" "ssh-web-sg-1" {
    vpc_id = aws_vpc.terraform-test-vpc.id
    tags = {
      Name="ssh-web-sg-1"
    }
}

resource "aws_instance" "test-aws_instance" {
    ami = "ami-0c101f26f147fa7fd"
    key_name = "moamjad-aws-auth-keys"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public-subnet-1.id
    vpc_security_group_ids = [ aws_security_group.ssh-web-sg-1.id ]
    tags = {
      Name = "terraform-02"
    }
}



resource "aws_vpc_security_group_ingress_rule" "test-ingress-1" {
    security_group_id = aws_security_group.ssh-web-sg-1.id
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_ipv4 = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_egress_rule" "test-egress-1" {
    security_group_id = aws_security_group.ssh-web-sg-1.id
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_ipv4 = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_ingress_rule" "test-ingress-2" {
    security_group_id = aws_security_group.ssh-web-sg-1.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_ipv4 = "0.0.0.0/0"
  
}

resource "aws_vpc_security_group_egress_rule" "test-egress-2" {
    security_group_id = aws_security_group.ssh-web-sg-1.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_ipv4 = "0.0.0.0/0"
  
}