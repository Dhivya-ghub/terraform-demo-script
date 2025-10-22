resource "aws_security_group" "allow_http" {
  name        = "allow_http1"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh1"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

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

resource "aws_security_group" "allow_jenkins" {
  name        = "allow_jenkins1"
  description = "Allow Jenkins inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
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

resource "aws_instance" "jenkins_master" {
  ami           = "ami-0cfde0ea8edd312d4"
  instance_type = "t3.micro"
  subnet_id     = var.subnet_id
  key_name      = "example_key_pair"
  user_data     = file("installation_jenkins.sh")

  # ✅ Use 'vpc_security_group_ids' instead of 'security_group_names'
  vpc_security_group_ids = [
    aws_security_group.allow_http.id,
    aws_security_group.allow_ssh.id,
    aws_security_group.allow_jenkins.id
  ]

  tags = {
    Name = "jenkins"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for Jenkins to initialize...'; sleep 2m",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file(var.private_key_path)   # <-- reference variable here
    }
  }
}
