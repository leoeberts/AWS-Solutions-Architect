resource "aws_security_group" "alb_sg" {
  name        = "study-alb-sg"
  description = "Allow HTTP from internet to ALB"
  vpc_id      = data.aws_vpc.study_vpc.id

  tags = {
    Name = "study-alb-sg"
  }
}

resource "aws_security_group_rule" "alb_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "alb_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_sg.id
}

resource "aws_lb" "study_alb" {
  name               = "study-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_b.id,
    data.aws_subnet.public_c.id
  ]

  tags = {
    Name = "study-alb"
  }
}

resource "aws_lb_target_group" "ec2_tg" {
  name        = "demo-tg-elb"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.study_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "ec2-tg"
  }
}

resource "aws_lb_target_group_attachment" "tg_ec2_att_a" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = aws_instance.instance_a.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_ec2_att_b" {
  target_group_arn = aws_lb_target_group.ec2_tg.arn
  target_id        = aws_instance.instance_b.id
  port             = 80
}

resource "aws_lb_listener" "study_listener" {
  load_balancer_arn = aws_lb.study_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ec2_tg.arn
  }
}

resource "aws_lb_listener_rule" "demo_rule" {
  listener_arn = aws_lb_listener.study_listener.arn
  priority     = 100

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Some custom error"
      status_code  = "404"
    }
  }

  condition {
    path_pattern {
      values = ["/error/*"]
    }
  }
}

