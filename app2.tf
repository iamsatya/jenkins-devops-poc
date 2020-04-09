resource "aws_instance" "app2" {
  instance_type = "t2.micro"
  ami           = "ami-03b5297d565ef30a6"
  key_name      = "aws"

  tags = {
    "type" = "terraform-test-instance"
	"Name" = "APP-Servers"
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.sg.id
  network_interface_id = aws_instance.app2.primary_network_interface_id
}