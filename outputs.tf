output "sg_id" {
  value = "${aws_security_group.this.id}"
}

output "lb_arn" {
  value = "${aws_lb.this.arn}"
}

output "lb_dns_name" {
  value = "${aws_lb.this.dns_name}"
}

output "lb_zone_id" {
  value = "${aws_lb.this.zone_id}"
}

output "listener_arn" {
  value = "${aws_lb_listener.https.arn}"
}
