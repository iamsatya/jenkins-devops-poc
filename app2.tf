resource "aws_instance" "app2" {
  instance_type = "t2.micro"
  ami           = "ami-03b5297d565ef30a6"
  key_name      = "aws"
  security_groups = aws_security_group.sg.id

  tags = {
    "type" = "terraform-test-instance"
	"Name" = "APP-Servers"
  }
}