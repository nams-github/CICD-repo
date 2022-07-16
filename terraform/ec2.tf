data "aws_ami" "aws-ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20220610"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.aws-ubuntu.id
  associate_public_ip_address = true
  instance_type               = "t2.medium"
  key_name                    = "June12"
  subnet_id                   = aws_subnet.public1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id] 

  tags = {
    Name = "bastion-server"
  }
}

resource "aws_instance" "jenkins" {
  ami                         = data.aws_ami.aws-ubuntu.id
  associate_public_ip_address = false
  instance_type               = "t2.medium"
  key_name                    = "June12"
  subnet_id                   = aws_subnet.private1.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id] 
  tags = {
    Name = "jenkins"
  }
}

resource "aws_instance" "app" {
    ami                         = data.aws_ami.aws-ubuntu.id
    associate_public_ip_address = false
    instance_type               = "t2.medium"
    key_name                    = "June12"
    subnet_id                   = aws_subnet.private1.id
    vpc_security_group_ids      = [aws_security_group.publicweb_sg.id] 
    user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install nginx -y
                systemctl enable nginx
                systemctl start nginx
                EOF
    tags = {
      Name = "app"
    }
  }
