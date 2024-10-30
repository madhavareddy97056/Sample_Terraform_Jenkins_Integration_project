resource "aws_instance" "jenkins-terrafrm-integration" {
  ami_id                    = "ami-0dee22c13ea7a9a67"
  availability_zone      = "ap-south-1a"
  instance_type          = "t2.micro"
  key_name               = "linuxkey"
  vpc_security_group_ids = ["sg-02cd4172d34747bc7"]
  tags = {
    Name = "Jenkins_terra_int_server"
  }
}
