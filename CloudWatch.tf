resource "aws_sns_topic" "devops" {
  name = "alarms-topic"
  
  provisioner "local-exec" {
    command = "aws sns subscribe --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
  }
  
  provisioner "local-exec" {
    when = "destroy"
    command = "aws sns list-subscriptions-by-topic --topic-arn ${self.arn} --output text --query 'Subscriptions[].[SubscriptionArn]' | grep '^arn:' | xargs -rn1 aws sns unsubscribe --subscription-arn"
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