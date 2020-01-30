resource "aws_eip" "lbpip" {
  vpc = true
}

resource "aws_lb" "rancher" {
  name               = "rancher"
  internal           = false
  load_balancer_type = "network"
  subnet_mapping {
    subnet_id     = var.subnet_id
    allocation_id = aws_eip.lbpip.id
  }
}

resource "aws_lb_listener" "port80" {
  load_balancer_arn = aws_lb.rancher.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg80.arn
  }
}

resource "aws_lb_listener" "port443" {
  load_balancer_arn = aws_lb.rancher.arn
  port              = "443"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg443.arn
  }
}

resource "aws_lb_target_group" "tg80" {
  name        = "ranchertg80"
  target_type = "instance"
  protocol    = "TCP"
  port        = 80
  vpc_id      = var.vpc_id

  health_check {
    protocol            = "TCP"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }

}

resource "aws_lb_target_group" "tg443" {
  name        = "ranchertg443"
  target_type = "instance"
  protocol    = "TCP"
  port        = 443
  vpc_id      = var.vpc_id

  health_check {
    protocol            = "TCP"
    port                = 443
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 10
  }

}

resource "aws_lb_target_group_attachment" "tga80" {
  count            = var.control_count
  target_group_arn = aws_lb_target_group.tg80.arn
  target_id        = aws_instance.rancher_server.*.id[count.index]
  port             = 443
}

resource "aws_lb_target_group_attachment" "tga443" {
  count            = var.control_count
  target_group_arn = aws_lb_target_group.tg443.arn
  target_id        = aws_instance.rancher_server.*.id[count.index]
  port             = 443
}

# Security group to allow all traffic
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "rancher-allowall"
  description = "Rancher quickstart - allow all traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Creator = "rancher-quickstart"
  }
}

# Temporary key pair used for SSH accesss
resource "aws_key_pair" "quickstart_key_pair" {
  key_name_prefix = "rancher"
  public_key      = file("~/.ssh/id_rsa.pub")
}

# AWS EC2 for creating a single node RKE cluster and installing the Rancher server
resource "aws_instance" "rancher_server" {
  depends_on = [
    aws_security_group.rancher_sg_allowall
  ]

  count           = var.control_count
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t3.medium"
  key_name        = aws_key_pair.quickstart_key_pair.key_name
  security_groups = [aws_security_group.rancher_sg_allowall.id]
  user_data       = file(var.userdata)
  subnet_id       = var.subnet_id

  tags = {
    Name    = "rancher-server"
    Creator = "rancher-quickstart"
  }

  provisioner "local-exec" {
    command    = "sleep 200"
    on_failure = continue
  }
}
