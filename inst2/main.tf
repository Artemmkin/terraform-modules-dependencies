resource "aws_instance" "web" {
  ami           = "ami-060cde69"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-490ea722"]

  tags {
    Name = "${var.name}"
  }
}
