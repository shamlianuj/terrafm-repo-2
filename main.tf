#  Configure the AWS Provider
provider "aws" {
  region = "ap-northeast-1"
  access_key = "AKIAZPORFBT3EI44D2OO"
  secret_key = "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"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "pub_subnet"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "pub-rt"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_instance" "mysec2" {
  ami           = "ami-0d979355d03fa2522"
  instance_type = "t2.micro"
  subnet_id     =  aws_subnet.public_subnet.id
}
