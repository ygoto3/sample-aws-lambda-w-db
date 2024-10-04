resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "main"
    }
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "ap-northeast-1a"

    tags = {
        Name = "public-subnet"
    }
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.10.0/24"
    availability_zone = "ap-northeast-1a"

    tags = {
        Name = "private-subnet"
    }
}

resource "aws_subnet" "private2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.11.0/24"
    availability_zone = "ap-northeast-1c"

    tags = {
        Name = "private-subnet"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "igw"
    }
}

resource "aws_eip" "eip" {
    domain = "vpc"

    tags = {
        Name = "eip"
    }
}

resource "aws_nat_gateway" "nat" {
    allocation_id   = aws_eip.eip.id
    subnet_id       = aws_subnet.public.id

    tags = {
        Name = "nat"
    }
}

resource "aws_route_table" "public" {
    vpc_id    = aws_vpc.main.id

    tags = {
        Name = "public-rtb"
    }
}

resource "aws_route" "public" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_route_table.public.id
    gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "private-rtb"
    }
}

resource "aws_route" "private" {
    destination_cidr_block = "0.0.0.0/0"
    route_table_id         = aws_route_table.private.id
    nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private.id
}
