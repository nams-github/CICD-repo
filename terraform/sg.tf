resource "aws_security_group" "bastion_sg" {
  name = "bastion_sg"
  description = "for accessing bastion machine"
  vpc_id = aws_vpc.main.id

 // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "private_sg" {
  name = "private-instance-sg"
  description = "for private instance"
  vpc_id = aws_vpc.main.id

 // To Allow SSH Transport
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["10.100.0.0/16"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "publicweb_sg" {
  name = "public_web_sg"
  description = "for accessing web server"
  vpc_id = aws_vpc.main.id

 // To Allow HTTP80
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

 // To Allow SSH Transport
  ingress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["10.100.0.0/16"]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
