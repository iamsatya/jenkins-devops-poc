data "aws_route53_zone" "cloud" {
  name         = "cloudlinuxacademy.com."
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.cloud.zone_id}"
  name    = "www.${data.aws_route53_zone.cloud.name}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.applb.dns_name}"]
}

resource "aws_sns_topic" "devops" {
  name = "devops"
  display_name = "devops"
}

resource "aws_sns_topic_subscription" "devops-team" {
  topic_arn = aws_sns_topic.devops.arn
  protocol  = "email"
  endpoint  = "satyapanuganti@gmail.com"
}

resource "aws_sns_topic_subscription" "devops-team" {
  topic_arn = aws_sns_topic.devops.arn
  protocol  = "email"
  endpoint  = "satyanarayana.pr@sonata-software.com"
}

module "health_check-cloudlinuxacademy" {
  source            = "https://github.com/Nuagic/terraform-aws-route53-health-check"
  fqdn              = "www.cloudlinuxacadem.com"
  port              = 80
  type              = "HTTP"
  resource_path     = "/"
  failure_threshold = "5"
  request_interval  = "30"
  sns_topic         = "${aws_sns_topic.devops.id}"
  name              = "APP alarm"
}