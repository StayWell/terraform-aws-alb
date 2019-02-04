data "aws_elb_service_account" "this" {}

resource "aws_s3_bucket" "this" {
  bucket = "${var.env}-alb-logs"
  acl    = "private"
  tags   = "${merge(map("Name", "${var.env}"), var.tags)}"

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.env}-alb-logs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.this.arn}"
        ]
      }
    }
  ]
}
POLICY

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "this" {
  name               = "${var.env}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.this.id}"]
  subnets            = ["${var.subnet_ids}"]
  tags               = "${merge(map("Name", "${var.env}"), var.tags)}"

  access_logs {
    bucket  = "${aws_s3_bucket.this.bucket}"
    enabled = true
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.this.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "${var.ssl_policy}"
  certificate_arn   = "${var.certificate_arn}"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No routing rule for host"
      status_code  = "400"
    }
  }
}

resource "aws_security_group" "this" {
  name_prefix = "${var.env}-alb-"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(map("Name", "${var.env}-alb"), var.tags)}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "http" {
  description       = "internet"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.this.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "https" {
  description       = "internet"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.this.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
