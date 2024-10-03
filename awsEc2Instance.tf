/*resource "aws_key_pair" "ticketea_key" {
  key_name   = "ticketea_key"
  public_key = file(local.public_key_path)
}

resource "aws_security_group" "ticketea_backend_security_group" {
  name        = "ticketea_backend_security_group"
  description = "Allow traffic"

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ticketea_instance" {
  ami             = local.instance_ami
  security_groups = [aws_security_group.ticketea_backend_security_group.name]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ticketea_key.key_name
  user_data       = file(local.userdata_path)

  depends_on = [null_resource.push_to_dockerhub_backend]
}

resource "aws_eip" "ticketea_elastic_ip" {
  vpc = false
}

resource "aws_eip_association" "ticketea_elastic_ip_association" {
  instance_id   = aws_instance.ticketea_instance.id
  allocation_id = aws_eip.ticketea_elastic_ip.id
}*/