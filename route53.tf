resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.primary.zone_id}"
  name    = "www.cloudlinuxacademy.com"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_lb.applb.dns_name}"]
}