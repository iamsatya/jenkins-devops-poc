resource "aws_instance" "instance" {
  instance_type = "t2.micro"
  image_id      = "ami-03b5297d565ef30a6"

  tags = {
    "type" = "terraform-test-instance"
  }
}