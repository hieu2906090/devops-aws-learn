locals {
  ami           = var.ami
  instance_type = var.instance_type
  name          = var.project_name

  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id
}

resource "aws_instance" "myapp" {
  ami           = local.ami
  instance_type = local.instance_type
  subnet_id     = local.subnet_id
  key_name      = "d13"
  user_data     = file("./modules/EC2/user_data.sh")
  tags = {
    Name = local.name
  }
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh-lab2"
  description = "Allow SSH inbound traffic"
  vpc_id      = local.vpc_id

  ingress { // inbound
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { // inbound
    description = "Allow SSH"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   ingress { // inbound
    description = "Allow SSH"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { // outbound
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
