resource "aws_lb" "applb" {
  name = "apploadbalancer"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups   = [aws_security_group.albsg.id]
}

data "aws_vpc" "default" {
  default          = true
  }

data "aws_subnet_ids" "default" {
  vpc_id           = data.aws_vpc.default.id
  }  
  
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.applb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"
	
	fixed_response {
	  content_type  = "text/plain"
	  message_body  = "404: page not found"
	  status_code   = 404
	}
  }
}

resource "aws_security_group" "albsg" {
  name              = "lb-sg"
  
  ingress {
    from_port       = 80
	to_port         = 80
	protocol        = "tcp"
	cidr_blocks     = ["0.0.0.0/0"]
	}
}

resource "aws_lb_target_group"  "apptg" {
  name              = "app-target-group"
  port              = 8080
  protocol          = "HTTP"
  vpc_id            = data.aws_vpc.default.id
  
  health_check {
    path            = "/"
    protocol        = "HTTP"
    matcher         = "200"
    interval        = 15
    timeout         = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
	}
}

resource "aws_lb_target_group_attachment" "app1tg" {
  target_group_arn = aws_lb_target_group.apptg.arn
  target_id        = aws_instance.app1.id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "app2tg" {
  target_group_arn = aws_lb_target_group.apptg.arn
  target_id        = aws_instance.app2.id
  port             = 8080
}

output "lb_address" {
  value     = aws_lb.applb.public_dns
  }