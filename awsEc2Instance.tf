resource "aws_key_pair" "ticketea_key" {
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

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
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
  ami                  = local.instance_ami
  security_groups      = [aws_security_group.ticketea_backend_security_group.name]
  instance_type        = "t2.medium"
  key_name             = aws_key_pair.ticketea_key.key_name
  user_data            = file(local.userdata_path)
  iam_instance_profile = aws_iam_instance_profile.ticketea_ec2_profile.name

  depends_on = [null_resource.push_to_dockerhub_backend,
  null_resource.push_to_dockerhub_frontend,
  aws_secretsmanager_secret_version.ticketea_secrets_version]
}

resource "aws_eip" "ticketea_elastic_ip" {
  vpc = false
}

resource "aws_eip_association" "ticketea_elastic_ip_association" {
  instance_id   = aws_instance.ticketea_instance.id
  allocation_id = aws_eip.ticketea_elastic_ip.id
}

resource "aws_iam_role" "ticketea_ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ticketea_ec2_secrets_policy" {
  role       = aws_iam_role.ticketea_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "ticketea_ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ticketea_ec2_role.name
}