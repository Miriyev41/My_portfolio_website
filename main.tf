provider "aws" {
  region = "eu-central-1"
}

# 1. Fetch your existing Route 53 Hosted Zone
data "aws_route53_zone" "portfolio_zone" {
  name         = "mirparvin.com"
  private_zone = false
}

# 2. Find the latest Ubuntu image for the server
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# 3. Create a Security Group (Firewall)
resource "aws_security_group" "web_sg" {
  name        = "portfolio_web_sg"
  description = "Allow HTTP, HTTPS, and SSH traffic"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. Create the EC2 Instance
resource "aws_instance" "django_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro" # Updated to modern Free Tier eligible instance
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = "portfolio-web-key"

  tags = {
    Name = "PortfolioWebServer"
  }
}

# 5. Attach an Elastic IP to the instance
resource "aws_eip" "web_eip" {
  instance = aws_instance.django_server.id
  domain   = "vpc"
}

# 6. Point your Route 53 Domain to the Elastic IP
resource "aws_route53_record" "root_domain" {
  zone_id         = data.aws_route53_zone.portfolio_zone.zone_id
  name            = "mirparvin.com"
  type            = "A"
  ttl             = "300"
  records         = [aws_eip.web_eip.public_ip]
  allow_overwrite = true
}