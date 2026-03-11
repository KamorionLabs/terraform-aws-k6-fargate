resource "aws_security_group" "k6" {
  name_prefix = "${var.name}-k6-"
  vpc_id      = var.vpc_id
  description = "Security group for k6 load testing tasks"

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-k6"
  })

  lifecycle {
    create_before_destroy = true
  }
}
