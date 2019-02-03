output "sg_id" {
  value       = "${aws_security_group.this.id}"
}

output "alb_arn" {
  value       = ${aws_lb.this.arn}
}

output "listener_arn" {
  value       = "${aws_lb_listener.https.arn}"
}
