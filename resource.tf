# Creating vpc
resource "aws_vpc" "project-vpc" {
  cidr_block = "12.0.0.0/16"
  tags = {
    Name = "reddy_vpc"
  }
}

# creating public subnet
resource "aws_subnet" "pub_subnet" {
  tags = {
    Name = "pub_sn_1a_12.0.1.0"
  }
  vpc_id                  = aws_vpc.project-vpc.id
  availability_zone       = "ap-south-1a"
  cidr_block              = "12.0.1.0/24"
  map_public_ip_on_launch = "true"
}

# Creating Internet gateway
resource "aws_internet_gateway" "project_IGW" {
  vpc_id = aws_vpc.project-vpc.id
  tags = {
    Name = "Project-IGW"
  }
}

# Creating custom Route Table for public subnet
resource "aws_route_table" "custom_RT" {
  vpc_id = aws_vpc.project-vpc.id
  tags = {
    Name = "custom_pub_RT"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project_IGW.id
  }
}

# Subnet associatins
resource "aws_route_table_association" "pub_rt_sn_association" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.custom_RT.id
}

# creating security_group
resource "aws_security_group" "project-sg" {
  vpc_id = aws_vpc.project-vpc.id
  tags = {
    Name = "project-SG"
  }
  dynamic "ingress" {
    for_each = [22, 80, 443, 8080]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Creating key_pair
resource "aws_key_pair" "pub-key" {
  key_name   = "provision"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDY3ThgTNL5+qHoW1q0EHHS2eEuK8H1QxnE/WOqvkdyYxaqA4797Kam69tDjHNkNMJxi4dgqy8AdUxJW0TVq5p0QhUyLGaCbJTngddZB9Z3/yoIlEHcnm68229+3Ak8Bz3OEM9EXY5lLQUXeMKbSlSI37ASUMbQZv7S8zDcwrHCMpb/pbmI9cXe0r38jtwno6ka8QZ1Zld74AjR+IgpqbR8TLIkhueldj81Xns6Bj/kHszOHOdKVfUVvpHZZvXH2hPFxebr8QFSIvGK6uKI6fSMohk4H2Sv8ZzbT5Q60erEfQok5hQtLybEHm76LCsvAw7Zq16MKjkJ5owBZ6HaIPKd/gB5Nmd+xDrmbPBKa0MjMKsQPlGZYzlWonLQqwMJL2umT3XJrPVtW8JmShOYW+h/N0Uzjrf6Lw7EikxebHQ877yXpKJzJ9ifpnxouYJ67CAiVdNd6XoX/KrrcWQ3qfccvfG89lZ8k01OOElXV1bHwdc0kMdUt+nHNIRCPCW/BD0= madhava@MADHAVA-HP"
}

# Creating ec2 instance with website
resource "aws_instance" "jenkins-server-ubuntu" {
  ami                    = "ami-0dee22c13ea7a9a67"
  subnet_id              = aws_subnet.pub_subnet.id
  instance_type          = "t2.micro"
  key_name               = "provision"
  vpc_security_group_ids = [aws_security_group.project-sg.id]
  tags = {
    Name = "webserver-ubuntu-project"
    Env  = "Testing-project"
  }
  user_data = <<-EOF
    #!/bin/bash
    sudo -i
    apt update
    apt install apache2 wget unzip -y
    cd /tmp/
    wget https://www.tooplate.com/zip-templates/2131_wedding_lite.zip
    unzip 2131_wedding_lite.zip
    cp -r 2131_wedding_lite/* /var/www/html
    systemctl restart apache2
    EOF
}
