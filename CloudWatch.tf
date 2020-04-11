resource "aws_sns_topic" "devops" {
  name = "alarms-topic"
  
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
}


resource "aws_cloudwatch_metric_alarm" "app1cpu" {
  alarm_name                = "app1-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app1.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "app1health" {
  alarm_name                = "app1-health-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app1.id}"
  }
}

resource "aws_route53_health_check" "cla-hc" {
  fqdn              = "www.cloudlinuxacademy.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    "Name" = "cla-hc"
  }
}

resource "aws_cloudwatch_metric_alarm" "cla-hc" {
  alarm_name          = "cla_healthcheck_failed"
  namespace           = "AWS/Route53"
  metric_name         = "HealthCheckStatus"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  period              = "60"
  statistic           = "Average"
  threshold           = "1"
  unit                = "None"

  dimensions = {
    HealthCheckId = aws_route53_health_check.cla-hc.id
  }

  alarm_description         = "This metric monitors cla.com whether the service endpoint is down or not."
  #alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]
  #insufficient_data_actions = [ "${aws_sns_topic.devops.arn}" ]
  treat_missing_data        = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "app2cpu" {
  alarm_name                = "app2-cpu-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app2.id}"
  }
}

resource "aws_cloudwatch_metric_alarm" "app2health" {
  alarm_name                = "app2-health-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors ec2 health status"
  alarm_actions             = [ "${aws_sns_topic.devops.arn}" ]

  dimensions = {
    InstanceId = "${aws_instance.app2.id}"
  }
}