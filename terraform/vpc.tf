resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}
resource "aws_subnet" "public1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.1.0/24"
  tags = {
    Name = "public1"
  }
  availability_zone = "us-east-1a"
}
resource "aws_subnet" "public2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.2.0/24"
  tags = {
    Name = "public2"
  }
  availability_zone = "us-east-1b"
}
resource "aws_subnet" "private1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.11.0/24"
  tags = {
    Name = "private1"
  }
  availability_zone = "us-east-1a"
}
resource "aws_subnet" "private2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.12.0/24"
  tags = {
    Name = "private2"
  }
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "elasticip" {
  vpc      = true
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_route_table" "IG_route_table" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "igw-rt"
  }
}

resource "aws_route_table" "NAT_route_table" {
  vpc_id = aws_vpc.main.id


  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "nat-rt"
  }
}

resource "aws_route_table_association" "public1_subnet1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.IG_route_table.id
}

resource "aws_route_table_association" "public2_subnet1_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.IG_route_table.id
}

resource "aws_route_table_association" "private1_subnet1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.NAT_route_table.id
}

resource "aws_route_table_association" "private2_subnet1_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.NAT_route_table.id
}


resource "aws_subnet" "db1_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.21.0/24"
  tags = {
    Name = "db_subnet1"
  }
}


resource "aws_subnet" "db-subnet2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.100.22.0/24"
  tags = {
    Name = "db-subnet2"
  }
}


resource "aws_route_table" "db_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block        = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "db-rt"
  }
}


